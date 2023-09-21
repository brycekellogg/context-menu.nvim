--   NeoTree:
--      - Diff file




-- ???
local function CheckEnable(opts)

    -- Neotree menu items are disabled if
    -- we are not in a neotree buffer.
    return "neo-tree" == opts.buf_filetype
end


-- ??
return {
    items = {

        -- ???
        ['neotree-git-stage'] = {
            display = "Git Stage File",
            enable = CheckEnable,
            action = function()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                require("neo-tree.sources.common.commands").git_add_file(state)
            end,
        },

        -- ???
        ['neotree-git-unstage'] = {
            display = "Git Unstage File",
            enable = CheckEnable,
            action = function()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                require("neo-tree.sources.common.commands").git_unstage_file(state)
            end,
        },

        -- ???
        ['neotree-copy-path'] = {
            display = "Copy Path",
            enable = CheckEnable,
            action = function()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                local path = state.tree:get_node().path
                vim.fn.setreg('+', path)
            end
        },

        -- TODO
        ['neotree-open-vert'] = {
            display = "Open in vertical split",
            enable = CheckEnable,
            action = function ()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                require("neo-tree.sources.common.commands").open_vsplit(state)
            end,
        },

        -- TODO
        ['neotree-open-horiz'] = {
            display = "Open in horizontal split",
            enable = CheckEnable,
            action = function ()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                require("neo-tree.sources.common.commands").open_split(state)
            end,
        },

        -- TODO
        ['neotree-toggle-hidden'] = {
            display = "Toggle hidden",
            enable = CheckEnable,
            action = function ()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                require("neo-tree.sources.filesystem.commands").toggle_hidden(state)
            end,
        },

        -- TODO
        -- Somehow add to diff?
        -- ['neotree-diff'] = {
        --
        -- }
    },
}
