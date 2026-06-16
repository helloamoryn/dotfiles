local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "EndOfBuffer",
  "LineNr",
  "FoldColumn",
  "NormalFloat",
  "FloatBorder",
}

local amoryn = {
  red = "#dc143c",
  bright_red = "#ff335f",
  dark_red = "#2a0f0f",
  foreground = "#f2f2f2",
  white = "#ffffff",
  dark_grey = "#3a3a3a",
  muted_grey = "#8a8a8a",
  soft_grey = "#a8a8a8",
}

local function extend_highlight(highlight, override)
  if type(highlight) ~= "table" then
    highlight = {}
  end

  return vim.tbl_extend("force", highlight, override)
end

return {
  {
    "wnkz/monoglow.nvim",
    priority = 1000,
    opts = {
      transparent = true,
      on_colors = function(colors)
        colors.glow = amoryn.red
        colors.error = amoryn.bright_red
        colors.fg = amoryn.foreground
        colors.white = amoryn.white
        colors.comment = amoryn.muted_grey
        colors.grey = amoryn.soft_grey
        colors.mode.insert = { bg = amoryn.red, fg = amoryn.white }
        colors.mode.command = { bg = amoryn.red, fg = amoryn.white }
      end,
      on_highlights = function(hl)
        for _, group in ipairs(transparent_groups) do
          hl[group] = extend_highlight(hl[group], { bg = "NONE" })
        end

        hl.CursorLine = extend_highlight(hl.CursorLine, { bg = amoryn.dark_grey })
        hl.Search = { fg = amoryn.white, bg = amoryn.dark_red }
        hl.IncSearch = { fg = amoryn.white, bg = amoryn.red }
        hl.DiagnosticError = { fg = amoryn.bright_red }
        hl.FloatBorder = { fg = amoryn.red, bg = "NONE" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monoglow",
    },
  },
}
