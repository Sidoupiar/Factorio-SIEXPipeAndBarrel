return
{
	name = "siexpb" ,
	settings =
	{
		barrel_stack_size = { "int" , "startup" , 10 , 1 , 1000000000 } ,
		barrel_size = { "int" , "startup" , 50 , 1 , 1000000000 } ,
		barrel_time = { "double" , "startup" , 0.2 , 0.000000001 , 1000000000.0 } ,
		barrel_need = { "bool" , "startup" , true } ,
		
		pipe_size = { "int" , "startup" , 100 , 1 , 1000000000 } ,
		pump_speed = { "int" , "startup" , 12000 , 1 , 1000000000 }
	}
}