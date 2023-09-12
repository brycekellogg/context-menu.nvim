local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")


-- what is M?
local M = {}

-- Git Actions
--   NeoTree:
--      - Add file
--      - Unstage file
--      - Diff file
--   Buffer:
--      - Add Chunk
--      - Diff Chunk
--      - Unstage Chunk

-- LSP Actions
--    - Refactor
--    - Find References
--    - Go to Definition
--    - 
M.config = {
    title = "Context Menu",
    settings = {
        -- TODO: full path on copy path or relative to CWD
    },
    items = {
        {
            "Git Add File",
            function ()
                return true
            end,
            function ()
                vim.api.nvim_echo({{"test"}}, false, {})
            end,
        },
        {
            "Git Unstage File",
            false,
            function ()
            end
        },
        {
            "Neotree: Copy Path",
            function ()
                return true
            end,
            function ()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                local node = state.tree:get_node()
                local abs_path = node.path
                vim.fn.setreg('+', abs_path)
            end
        },
    },

    picker = require("telescope.themes").get_dropdown({layout_config={width=0.3}})
}


-- ???
--
--
local function entry_maker(entry)

    -- Each menu item gets to decide if it is valid
    -- via a callback function. This can be overridden
    -- by using false instead of a function.
    local valid = entry[2]
    if type(valid) == "function" then
        valid = valid()
    end

    -- This is what telescope needs
    return {
        value   = entry,
        display = entry[1],  -- string that gets displayed by Telescope
        ordinal = entry[1],  -- how Telescope sorts entries
        valid   = valid,     -- true to show, false to hide
        action  = entry[3],  -- a function to call when selected
    }
end


-- Setup function
--
--
function M.setup(opts)

    -- Combine the default configuration with the options passed
    -- via the plugin manager. Use the passed in options if
    -- there is a conflict so we can override configuration.
    opts = vim.tbl_deep_extend('force', M.config, opts)

    -- vim.api.nvim_echo({{vim.inspect(opts)}}, true, {})

    -- Define the static finder
    local finder = finders.new_table({
        results = opts.items,
        entry_maker = entry_maker
    })

    -- Define the picker
    M.picker = pickers.new(opts.picker, {
        prompt_title = opts.title,
        finder = finder,
        sorter = conf.generic_sorter(opts.picker),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                selection.action()
            end)
            return true
        end,
    })
end


-- to execute the function
--
function M.menu()
    M.picker:find()
end

-- Why do we return M?
return M
