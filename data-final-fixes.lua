-- ------------------------------------------------------------------------------------------------
-- -------- 创建装桶配方 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

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
		local baseColor = table.deepcopy( fluid.base_color )
		local flowColor = table.deepcopy( fluid.flow_color )
		baseColor.a = 0.75
		flowColor.a = 0.75
		local item = SIGen.GetData( SITypes.item.item , name.."-barrel" )
		if item then
			local barrelName = SIGen.NewSubGroup( "siexpb-barrel" )
			.NewItem( "barrel-"..name , item.stack_size )
			.Inserter.Clear()
			.Inserter.ClearIcons()
			.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."item/barrel.png" )
			.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."item/barrel-side.png" , baseColor )
			.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."item/barrel-top.png" , flowColor )
			.GetCurrentEntityName()
			if SIGen.GetData( SITypes.recipe , "fill-"..name.."-barrel" ) then
				local ingredients = { SIPackers.SingleFluidIngredient( name , size , minTemperature , maxTemperature ) }
				if need then table.insert( ingredients , SIPackers.SingleItemIngredient( "empty-barrel" , 1 ) ) end
				table.insert( recipes , SIGen.NewSubGroup( "siexpb-barrel-fill" )
				.NewRecipe( "fill-"..barrelName )
				.Inserter.Clear()
				.Inserter.ClearIcons()
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-fill.png" )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-fill-side.png" , baseColor )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-fill-top.png" , flowColor )
				.Inserter.InsertIconFromData( 0 , fluid , vscale , { 4 , -8 } )
				.SetEnergy( time )
				.AddCosts( ingredients )
				.AddResults( SIPackers.SingleItemProduct( barrelName , 1 , nil , nil , 1 ) )
				.GetCurrentEntityName() )
			end
			if SIGen.GetData( SITypes.recipe , "empty-"..name.."-barrel" ) then
				local products = { SIPackers.SingleFluidProduct( name , size , nil , nil , minTemperature , size ) }
				if need then table.insert( products , SIPackers.SingleItemProduct( "empty-barrel" , 1 , nil , nil , 1 ) ) end
				table.insert( recipes , SIGen.NewSubGroup( "siexpb-barrel-empty" )
				.NewRecipe( "empty-"..barrelName )
				.Inserter.Clear()
				.Inserter.ClearIcons()
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-empty.png" )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-empty-side.png" , baseColor )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-empty-top.png" , flowColor )
				.Inserter.InsertIconFromData( 0 , fluid , vscale , { 7 , 8 } )
				.SetEnergy( time )
				.AddCosts( barrelName )
				.AddResults( products )
				.GetCurrentEntityName() )
			end
		end
	end
	if #recipes > 0 then
		local handling = SIGen.GetData( SITypes.technology , "fluid-handling" )
		local unit = handling.unit
		unit.count = unit.count * 2
		SIGen.NewTechnology( "fluid-handling" )
		.AddTechnologies( "fluid-handling" )
		.AddCosts( unit )
		.AddResult( SIPackers.RecipeModifiers( recipes ) )
	end
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