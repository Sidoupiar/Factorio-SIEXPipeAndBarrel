-- ------------------------------------------------------------------------------------------------
-- -------- 创建装桶配方 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local stackSize = SIStartup.SIEXPB.barrel_stack_size()
local size = SIStartup.SIEXPB.barrel_size()
local time = SIStartup.SIEXPB.barrel_time()
local need = SIStartup.SIEXPB.barrel_need()
if size ~= 50 or time ~= 0.2 or not need then
	if stackSize < 1 then stackSize = 1 end
	if size < 1 then size = 1 end
	local recipes = {}
	SIGen.Init( SIEXPB ).NewGroup( "extensions" )
	for name , fluid in pairs( SIGen.GetList( SITypes.fluid ) ) do
		local vscale = 16 / ( fluid.icon_size or SINumbers.iconSize )
		local baseColor = table.deepcopy( fluid.base_color )
		local flowColor = table.deepcopy( fluid.flow_color )
		baseColor.a = 0.75
		flowColor.a = 0.75
		local fluidName = fluid.localised_name and fluid.localised_name or { fluid.type.."-name."..fluid.name }
		if SIGen.GetData( SITypes.item.item , name.."-barrel" ) then
			local barrelName = SIGen.NewSubGroup( "siexpb-barrel" )
			.NewItem( "barrel-"..name , stackSize )
			.SetLocalisedNames{ "SIEXPB.barrel" , fluidName }
			.Inserter.Clear()
			.Inserter.ClearIcons()
			.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."item/barrel.png" )
			.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."item/barrel-side.png" , baseColor )
			.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."item/barrel-top.png" , flowColor )
			.GetCurrentEntityName()
			if SIGen.GetData( SITypes.recipe , "fill-"..name.."-barrel" ) then
				local ingredients = { SIPackers.SingleFluidIngredient( name , size ) }
				if need then table.insert( ingredients , SIPackers.SingleItemIngredient( "empty-barrel" , 1 ) ) end
				table.insert( recipes , SIGen.NewSubGroup( "siexpb-barrel-fill" )
				.NewRecipe( "fill-"..barrelName )
				.SetLocalisedNames{ "SIEXPB.fill" , fluidName }
				.Inserter.Clear()
				.Inserter.ClearIcons()
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-fill.png" )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-fill-side.png" , baseColor )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-fill-top.png" , flowColor )
				.Inserter.InsertIconFromData( 0 , fluid , vscale , { 4 , -8 } )
				.SetEnergy( time )
				.SetRecipeTypes( "crafting-with-fluid" )
				.SetCosts( ingredients )
				.SetResults{ SIPackers.SingleItemProduct( barrelName , 1 , nil , nil , 1 ) }
				.GetCurrentEntityName() )
			end
			if SIGen.GetData( SITypes.recipe , "empty-"..name.."-barrel" ) then
				local products = { SIPackers.SingleFluidProduct( name , size , nil , nil , nil , size ) }
				if need then table.insert( products , SIPackers.SingleItemProduct( "empty-barrel" , 1 , nil , nil , 1 ) ) end
				table.insert( recipes , SIGen.NewSubGroup( "siexpb-barrel-empty" )
				.NewRecipe( "empty-"..barrelName )
				.SetLocalisedNames{ "SIEXPB.empty" , fluidName }
				.Inserter.Clear()
				.Inserter.ClearIcons()
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-empty.png" )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-empty-side.png" , baseColor )
				.Inserter.InsertIcon( 0 , SIEXPB.picturePath.."recipe/barrel-empty-top.png" , flowColor )
				.Inserter.InsertIconFromData( 0 , fluid , vscale , { 7 , 8 } )
				.SetEnergy( time )
				.SetRecipeTypes( "crafting-with-fluid" )
				.SetCosts( barrelName )
				.SetResults( products )
				.GetCurrentEntityName() )
			end
		end
	end
	SIGen.FinishData().Inserter.Clear()
	if #recipes > 0 then
		local handling = SIGen.GetData( SITypes.technology , "fluid-handling" )
		local unit = handling.unit
		unit.count = unit.count * 2
		SIGen.NewTechnology( "fluid-handling" )
		.AddTechnologies( "fluid-handling" )
		.SetCosts( unit )
		.SetResults( SIPackers.RecipeModifiers( recipes ) )
	end
	SIGen.Finish()
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