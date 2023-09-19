--   NeoTree:
--      - Add file
--      - Unstage file
--      - Diff file


-- ???
--
local function CopyPath()
    local state = require("neo-tree.sources.manager").get_state_for_window()
    local path = state.tree:get_node().path
    vim.fn.setreg('+', path)
end


-- ??
--
local function GitAdd()
    local state = require("neo-tree.sources.manager").get_state_for_window()
    require("neo-tree.sources.common.commands").git_add_file(state)
end


-- ??
--
local function GitUnstage()
    local state = require("neo-tree.sources.manager").get_state_for_window()
    require("neo-tree.sources.common.commands").git_unstage_file(state)
end


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
            action = GitAdd,
        },

        -- ???
        ['neotree-git-unstage'] = {
            display = "Git Unstage File",
            enable = CheckEnable,
            action = GitUnstage,
        },

        -- ???
        ['neotree-copy-path'] = {
            display = "Copy Path",
            enable = CheckEnable,
            action = CopyPath,
        },
    },
}
