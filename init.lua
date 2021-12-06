gates_long = {}

local fence_collision_extra = minetest.settings:get_bool("enable_fence_tall") and 3/8 or 0

gates_long.register_gate = function(type_name, desc, tiles, craft_from)

	-- the closed version contains the string "fence" in its name - thus preventing mobs from jumping over
	local gate_closed_name = "gates_long:fence_gate_closed_" .. type_name
	local gate_open_name = "gates_long:gate_open_" .. type_name

	minetest.register_node(gate_closed_name, {
		description = desc.." fence gate (closed)",
		drawtype = "nodebox",
		-- top, bottom, side1, side2, inner, outer
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
		node_box = {
			type = "fixed",
			fixed = {
				-- horizontal wood
				{ -0.85, -0.25, -0.02, -0.005, -0.05,  0.02 },
				{ -0.85,  0.15, -0.02, -0.005,  0.35,  0.02 },

				{  0.005, -0.25, -0.02,  0.85, -0.05,  0.02 },
				{  0.005,  0.15, -0.02,  0.85,  0.35,  0.02 },

				-- vertical wood
				{ -0.80, -0.05, -0.02, -0.60,  0.15,  0.02 },
				{  0.60, -0.05, -0.02,  0.80,  0.15,  0.02 },

				{ -0.25, -0.05, -0.02, -0.05,  0.15,  0.02 },
				{  0.05, -0.05, -0.02,  0.25,  0.15,  0.02 },

				-- locking mechanism (top)
				{ -0.15,  0.32, -0.01,  0.15,  0.38,  0.01 },
				-- locking mechanism (bottom)
				{ -0.15, -0.28, -0.01,  0.15, -0.22,  0.01 },

				-- hinges for the horizontal wood
				{ -0.91, -0.24, -0.015, -0.84, -0.06,  0.015 },
				{ -0.91,  0.16, -0.015, -0.84,  0.34,  0.015 },

				{  0.84, -0.24, -0.015,  0.91, -0.06,  0.015 },
				{  0.84,  0.16, -0.015,  0.91,  0.34,  0.015 },
			},
		},
		collision_box = {
			type = "fixed",
			fixed = { -(1/2 + 3/8), -1/2, -1/8, (1/2 + 3/8), 1/2 + fence_collision_extra, 1/8 },
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.85, -0.25, -0.1,  0.85,  0.35,  0.1},
			},
		},
		on_rightclick = function(pos, node, puncher)
			minetest.swap_node(pos, {name = gate_open_name, param2 = node.param2})
			local timer = minetest.get_node_timer(pos)
			timer:start(5)
		end,
		is_ground_content = false,
	})


	minetest.register_node(gate_open_name, {
		description = desc.." fence gate (open)",
		drawtype = "nodebox",
		-- top, bottom, side1, side2, inner, outer
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drop = gate_closed_name,
		groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1 },
		node_box = {
			type = "fixed",
			fixed = {
				-- horizontal wood
				{ -0.87, -0.25, -0.02, -0.83,  -0.05,  0.85 },
				{ -0.87,  0.15, -0.02, -0.83,   0.35,  0.85 },

				{  0.83, -0.25, -0.02,  0.87, -0.05,  0.85 },
				{  0.83,  0.15, -0.02,  0.87,  0.35,  0.85 },

				-- vertical wood
				{ -0.87, -0.05,  0.80, -0.83,  0.15,  0.60 },
				{ -0.87, -0.05,  0.25, -0.83,  0.15,  0.05 },

				{  0.83, -0.05,  0.80,  0.87,  0.15,  0.60 },
				{  0.83, -0.05,  0.25,  0.87,  0.15,  0.05 },

				-- locking mechanism (top) - they are only on one side
				{ -0.86,  0.32,  0.53, -0.84,  0.38,  0.83 },
				-- locking mechanism (bottom) - these as well
				{ -0.86, -0.28,  0.53, -0.84, -0.22,  0.83 },

				-- hinges for the horizontal wood (they remain the same)
				{ -0.91, -0.24, -0.015, -0.84, -0.06,  0.015 },
				{ -0.91,  0.16, -0.015, -0.84,  0.34,  0.015 },

				{  0.84, -0.24, -0.015,  0.91, -0.06,  0.015 },
				{  0.84,  0.16, -0.015,  0.91,  0.34,  0.015 },
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.90, -0.25, 0,  0.90,  0.35,  0.50 },
			},
		},
		on_rightclick = function(pos, node, puncher)
		    minetest.swap_node(pos, {name = gate_closed_name, param2 = node.param2})
		end,
		on_timer = function(pos)
			old_node = minetest.get_node(pos)
			if old_node.name == gate_open_name then
				minetest.swap_node(pos, {name = gate_closed_name, param2 = old_node.param2})
			end
		end,
		is_ground_content = false,
	})


	minetest.register_craft({
		output = gate_closed_name .. " 2",
		recipe = {
			{ "default:steel_ingot", craft_from, "default:steel_ingot" },
			{ "",		                 craft_from, ""                    },
		}
	})

end


gates_long.register_gate( 'wood',      'wooden',    {'default_wood.png'},	"default:wood" )
gates_long.register_gate( 'junglewood','junglewood',{'default_junglewood.png'},  "default:junglewood" )
gates_long.register_gate( 'pine',      'pine',      {'default_pine_wood.png'},   "default:pine_wood" )
gates_long.register_gate( 'acacia',    'acacia',    {'default_acacia_wood.png'}, "default:acacia_wood" )
gates_long.register_gate( 'tree',      'tree',      {'default_tree.png^[transformR90'}, "default:tree" )
