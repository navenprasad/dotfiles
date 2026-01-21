# Theme for Kanagawa wave

return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  priority = 1000,
  lazy = false,
  config = function()
    require("kanagawa").setup({
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
      colors = {
        theme = {
          all = {
            ui = {
              bg = "#1F1F28",
              bg_gutter = "none",
            },
          },
        },
      },
    })
    vim.cmd("colorscheme kanagawa-wave")
  end,
}
