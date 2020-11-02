-- ------------------------------------------------------------------------------------------------
-- -------- 创建装桶配方 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local emptyBarrel = SIPackers.SingleItemProduct( "empty-barrel" , 1 , nil , nil , 1 )
local minTemperature = 15
local maxTemperature = 15

local size = SIStartup.SIEXPB.barrel_size()
local time = SIStartup.SIEXPB.barrel_time()
local need = SIStartup.SIEXPB.barrel_need()
if size ~= 50 or time ~= 0.2 or not need then
	if size < 1 then size = 1 end
	local recipes = {}
	SIGen.Init( SIEXPB ).NewGroup( "extensions" )
	for name , fluid in pairs( SIGen.GetList( SITypes.fluid ) ) do
		local vscale = 16 / fluid.icon_size
		local item = SIGen.GetData( SITypes.item.item , name.."-barrel" )
		local baseColor = table.deepcopy( fluid.base_color )
		local flowColor = table.deepcopy( fluid.flow_color )
		baseColor.a = 0.75
		flowColor.a = 0.75
		if item then
			local barrelName = SIGen.NewSubGroup( "siexpb-barrel" )
			.NewItem( "barrel-"..name , item.stack-size )
			.SetIcon( SIEXPB.picturePath.."item/barrel.png" )
			.AddIcon( SIEXPB.picturePath.."item/barrel-side.png" , baseColor )
			.AddIcon( SIEXPB.picturePath.."item/barrel-top.png" , flowColor )
			.GetCurrentEntityName()
			local fillBarrel = SIGen.GetData( SITypes.recipe , "fill-"..name.."-barrel" )
			local fluidIngredient = SIPackers.SingleFluidIngredient( name , size , minTemperature , maxTemperature )
			if fillBarrel then
				
			end
			local emptyBarrel = SIGen.GetData( SITypes.recipe , "empty-"..name.."-barrel" )
			local fluidProduct = SIPackers.SingleFluidProduct( name , size , nil , nil , minTemperature , size )
			if emptyBarrel then
				
			end
		end
	end
	for name , fluid in pairs( SIGen.GetList( SITypes.fluid ) ) do
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

-- ------------------------------------------------------------------------------------------------
-- -------- 调整管道容量 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local psize = SIStartup.SIEXPB.pipe_size()
psize = psize / 100
if psize ~= 1 then
	for k , v in pairs( SIGen.GetList( SITypes.entity.pipe ) ) do v.fluid_box.base_area = psize end
	for k , v in pairs( SIGen.GetList( SITypes.entity.pipeGround ) ) do v.fluid_box.base_area = psize end
end

-- ------------------------------------------------------------------------------------------------
-- ------- 调整管道泵速度 -------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local speed = SIStartup.SIEXPB.pump_speed()
speed = speed / 60
if speed ~= 200 then
	for k , v in pairs( SIGen.GetList( SITypes.entity.pump ) ) do v.pumping_speed = speed end
end