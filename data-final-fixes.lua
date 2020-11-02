local size = SIStartup.siex_barrel.barrel_size()
local time = SIStartup.siex_barrel.barrel_time()
local need = SIStartup.siex_barrel.barrel_need()
if size ~= 50 or time ~= 0.2 or not need then
	if size < 1 then size = 1 end
	local list = {}
	local name = {}
	local iorder = 0
	local forder = 0
	local eorder = 0
	local eb
	local vscale
	local item
	local fill
	local empt
	local fl
	local sc
	local tc
	local n
	local barrel
	if need then eb = { type = "item" , name = "empty-barrel" , amount = 1 , catalyst_amount = 1 } end
	for k , v in pairs( SICF.list( SIType.fluid ) ) do
		vscale = 16.0 / v.icon_size
		item = SICF.data( SIType.item.item , k.."-barrel" )
		fill = SICF.data( SIType.recipe , "fill-"..k.."-barrel" )
		empt = SICF.data( SIType.recipe , "empty-"..k.."-barrel" )
		fl = { type = "fluid" , name = k , amount = size , catalyst_amount = size }
		sc = table.deepcopy( v.base_color )
		tc = table.deepcopy( v.flow_color )
		sc.a = 0.75
		tc.a = 0.75
		if item then
			iorder = iorder + 1
			n = SIEX_BARREL.realname .. "barrel-" .. k
			barrel = { { type = "item" , name = n , amount = 1 , catalyst_amount = 1 } }
			item = table.deepcopy( item )
			item.name = n
			item.icon = nil
			item.icons =
			{
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-barrel.png" ) ,
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-barrel-side.png" , sc ) ,
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-barrel-top.png" , tc )
			}
			item.subgroup = "sicfl-group-extensions-barrel-item"
			item.order = iorder
			table.insert( list , item )
		end
		if fill then
			forder = forder + 1
			n = SIEX_BARREL.realname .. "fill-" .. k
			fill = table.deepcopy( fill )
			fill.name = n
			fill.icon = nil
			fill.icons =
			{
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-fill.png" ) ,
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-fill-side.png" , sc ) ,
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-fill-top.png" , tc )
			}
			if v.icon then table.insert( fill.icons , SICF.gen.iconitem( v.icon , nil , vscale , { 4 , -8 } , v.icon_size , v.icon_mipmaps ) )
			elseif v.icons then
				for n , m in pairs( v.icons ) do
					local shift = { 4 , -8 }
					local scale = vscale
					if m.shift then
						shift[1] = shift[1] + m.shift[1] * scale
						shift[2] = shift[2] + m.shift[2] * scale
					end
					if m.scale then scale = scale * m.scale end
					table.insert( fill.icons , SICF.gen.iconitem( m.icon , m.tint , scale , shift , m.icon_size , m.icon_mipmaps ) )
				end
			end
			fill.energy_required = time
			fill.always_show_products = true
			fill.ingredients = {}
			table.insert( fill.ingredients , fl )
			if need then table.insert( fill.ingredients , eb ) end
			fill.result = nil
			fill.results = barrel
			fill.subgroup = "sicfl-group-extensions-barrel-fill"
			fill.order = forder
			table.insert( list , fill )
			table.insert( name , n )
		end
		if empt then
			eorder = eorder + 1
			n = SIEX_BARREL.realname .. "empty-" .. k
			empt = table.deepcopy( empt )
			empt.name = n
			empt.icon = nil
			empt.icons =
			{
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-empt.png" ) ,
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-empt-side.png" , sc ) ,
				SICF.gen.iconitem( SIEX_BARREL.pp.."items/item-empt-top.png" , tc )
			}
			if v.icon then table.insert( empt.icons , SICF.gen.iconitem( v.icon , nil , vscale , { 7 , 8 } , v.icon_size , v.icon_mipmaps ) )
			elseif v.icons then
				for n , m in pairs( v.icons ) do
					local shift = { 7 , 8 }
					local scale = vscale
					if m.shift then
						shift[1] = shift[1] + m.shift[1] * scale
						shift[2] = shift[2] + m.shift[2] * scale
					end
					if m.scale then scale = scale * m.scale end
					table.insert( empt.icons , SICF.gen.iconitem( m.icon , m.tint , scale , shift , m.icon_size , m.icon_mipmaps ) )
				end
			end
			empt.energy_required = time
			empt.always_show_products = true
			empt.ingredients = barrel
			empt.result = nil
			empt.results = {}
			table.insert( empt.results , fl )
			if need then table.insert( empt.results , eb ) end
			empt.subgroup = "sicfl-group-extensions-barrel-empt"
			empt.order = eorder
			table.insert( list , empt )
			table.insert( name , n )
		end
	end
	if #list > 0 then SICF.extend( list ) end
	local tech = table.deepcopy( SICF.data( SIType.tech , "fluid-handling" ) )
	tech.name = SIEX_BARREL.realname .. "fluid-handling"
	tech.icon = SIEX_BARREL.pp .. "techs/tech-fluid-handling.png"
	tech.prerequisites = { "fluid-handling" }
	tech.effects = SICF.gen.tech_recipes( name )
	tech.unit.count = tech.unit.count * 2
	tech.order = SIEX_BARREL.order_name .. "[fluid-handling]"
	SICF.extend{ tech }
end

local psize = SIStartup.siex_barrel.pipe_size()
psize = psize / 100
if psize ~= 1 then
	for k , v in pairs( data.raw.pipe ) do v.fluid_box.base_area = psize end
	for k , v in pairs( data.raw["pipe-to-ground"] ) do v.fluid_box.base_area = psize end
end

local speed = SIStartup.siex_barrel.pump_speed()
speed = speed / 60
if speed ~= 200 then
	for k , v in pairs( data.raw.pump ) do v.pumping_speed = speed end
end