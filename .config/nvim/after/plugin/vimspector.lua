local M = {}

function M.toggle_human_mode()
  if vim.g.vimspector_enable_mappings == nil then
    vim.g.vimspector_enable_mappings = "HUMAN"
  else
    vim.g.vimspector_enable_mappings = nil
  end
end

--M.toggle_human_mode()
-- vim.cmd [[packadd! vimspector]] -- Load vimspector
-- vim.cmd("let g:vimspector_base_dir='/home/cshoop/.local/nvim/site/pack/packer/start/vimspector'")

vim.keymap.set("n", "<leader>dl", ":call vimspector#Launch()<cr>")
-- vim.keymap.set("n", "<leader>r", ":call vimspector#Launch()<cr>")
vim.keymap.set("n", "<leader>dr", ":call vimspector#Restart()<cr>")
vim.keymap.set("n", "<leader>dq", ":call vimspector#Reset()<cr>")
vim.keymap.set("n", "<leader>dc", ":call vimspector#Continue()<cr>")
vim.keymap.set("n", "<leader>db", ":call vimspector#ToggleBreakpoint()<cr>")
vim.keymap.set("n", "<leader>dn", ":call vimspector#StepOver()<cr>")
vim.keymap.set("n", "<leader>df", ":call vimspector#StepOut()<cr>")
vim.keymap.set("n", "<leader>ds", ":call vimspector#StepInto()<cr>")
vim.keymap.set("n", "<leader>dd", ":call vimspector#DownFrame()<cr>")
vim.keymap.set("n", "<leader>du", ":call vimspector#UpFrame()<cr>")
vim.keymap.set("n", "<leader>dB", ":VimspectorBreakpoints<cr>")
vim.keymap.set("n", "<leader>dm", ":call vimspector#GoToCurrentLine()<cr>")
vim.keymap.set("n", "<leader>di", "<Plug>VimspectorBalloonEval<cr>")
