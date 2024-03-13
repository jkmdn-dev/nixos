local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>q",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n",
  "<leader>te",
  function()
    local file = vim.api.nvim_buf_get_name(bufnr)
    -- non-blocking loop
    --
    print("Running rustdoc on " .. file)

    -- like belov but in a new_thread
    local obj = vim.system({ "rustdoc", "--test", file }, { capture_output = true, text = true })

    -- vertical split
    local Split = require("nui.split")
    local split = Split({
      type = "c",
      relative = "editor",
      position = "bottom",
      size = "50%",
      enter = true,
      buf_options = {
        -- Set the buf to be filetype=markdown
        filetype = "shell",
        -- Set the buf to not be modifiable
        modifiable = false,
      },

    }).


    obj:wait()
    split:mount(obj.stdout)
  end,
  { silent = true, buffer = bufnr }
)

local autogrp = vim.api.nvim_create_augroup("my-rust-autocmd", { clear = true })

local start_inlay = vim.api.nvim_create_autocmd("BufWinEnter", {
  group = autogrp,
  pattern = "*.rs",
  callback = function()
    vim.lsp.inlay_hint.enable(0, true)
  end
})

-- modeline
-- vim: ts=2 sts=2 sw=2 et
