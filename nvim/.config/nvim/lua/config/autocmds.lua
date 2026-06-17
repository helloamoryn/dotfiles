local autosave = vim.api.nvim_create_augroup("amoryn_autosave", { clear = true })

local function save_buffer()
  if vim.bo.buftype ~= "" or not vim.bo.modifiable or vim.bo.readonly then
    return
  end

  if vim.api.nvim_buf_get_name(0) == "" or not vim.bo.modified then
    return
  end

  vim.cmd("silent! noautocmd write")
end

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave", "CursorHold" }, {
  group = autosave,
  callback = save_buffer,
})
