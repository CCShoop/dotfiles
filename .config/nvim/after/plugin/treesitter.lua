-- nvim-treesitter (main branch): installs parsers/queries only.
-- Highlighting is Neovim's built-in vim.treesitter.start().
-- Requires the tree-sitter CLI (>= 0.26.1) and a C compiler to build parsers.
local ts = require('nvim-treesitter')

local ensure_installed = {
    "java", "c", "cpp", "lua", "vim", "vimdoc", "query",
    "python", "bash", "json", "markdown", "markdown_inline", "gitcommit", "gitignore",
}
local ignore_install = { "javascript" }

ts.install(ensure_installed)

-- Start highlighting on FileType, auto-installing missing parsers (replaces
-- the old `highlight.enable` + `auto_install = true`).
local available = nil
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('shoop-treesitter', { clear = true }),
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang or vim.tbl_contains(ignore_install, lang) then
            return
        end

        if pcall(vim.treesitter.start, args.buf, lang) then
            return
        end

        available = available or ts.get_available()
        if not vim.tbl_contains(available, lang) then
            return
        end
        ts.install(lang):await(vim.schedule_wrap(function()
            if vim.api.nvim_buf_is_loaded(args.buf) then
                pcall(vim.treesitter.start, args.buf, lang)
            end
        end))
    end,
})


-- textobjects (main branch): options via setup, keymaps defined manually
require('nvim-treesitter-textobjects').setup {
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- Extend textobjects to include preceding or succeeding whitespace,
        -- like the built-in `ap`.
        include_surrounding_whitespace = true,
    },
    move = {
        set_jumps = true, -- whether to set jumps in the jumplist
    },
}

local select = require('nvim-treesitter-textobjects.select')
local move = require('nvim-treesitter-textobjects.move')

local function map_select(lhs, query, group, desc)
    vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, group or "textobjects")
    end, { desc = desc })
end

-- You can use the capture groups defined in textobjects.scm
map_select("af", "@function.outer")
map_select("if", "@function.inner")
map_select("ac", "@class.outer")
map_select("ic", "@class.inner", nil, "Select inner part of a class region")
-- You can also use captures from other query groups like `locals.scm`
map_select("as", "@local.scope", "locals", "Select language scope")

local function map_move(lhs, fn, query, group, desc)
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
        move[fn](query, group or "textobjects")
    end, { desc = desc })
end

map_move("]m", "goto_next_start", "@function.outer")
map_move("]]", "goto_next_start", "@class.outer", nil, "Next class start")
-- Pass a list to group multiple queries
map_move("]o", "goto_next_start", { "@loop.inner", "@loop.outer" })
-- Queries from other groups (`locals.scm`, `folds.scm`)
map_move("]s", "goto_next_start", "@local.scope", "locals", "Next scope")
map_move("]z", "goto_next_start", "@fold", "folds", "Next fold")

map_move("]M", "goto_next_end", "@function.outer")
map_move("][", "goto_next_end", "@class.outer")

map_move("[m", "goto_previous_start", "@function.outer")
map_move("[[", "goto_previous_start", "@class.outer")

map_move("[M", "goto_previous_end", "@function.outer")
map_move("[]", "goto_previous_end", "@class.outer")

-- Go to either the start or the end, whichever is closer.
map_move("]d", "goto_next", "@conditional.outer")
map_move("[d", "goto_previous", "@conditional.outer")


local M = {}

function M.get_current_function_name()
    local expr = vim.treesitter.get_node()

    while expr do
        if expr:type() == 'function_definition' then
            break
        end
        expr = expr:parent()
    end

    if not expr or not expr:child(1) then
        return ""
    end

    return vim.treesitter.get_node_text(expr:child(1), 0)
end

vim.api.nvim_create_user_command("TestTS", function() print(M.get_current_function_name()) end, {})
