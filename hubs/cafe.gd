extends Node2D

#loading customer
var customer_scene:PackedScene=load("res://assets/cafe/customers/customer.tscn")

func _ready():
	pass
	
func _process(_delta):
	pass
	
func _on_customer_timer_timeout():
	#creating instance
	var customer = customer_scene.instantiate()
	#attaching a customer to scene tree
	$customers.add_child(customer)
	print('customer added to scene')
