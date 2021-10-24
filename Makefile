help:
	@grep '####' Makefile | grep -v grep | sed -e 's/####//'

cart: #### Setup Cart Component
	@bash components/cart.sh

catalogue: #### Setup Catalogue Component
	@bash components.catalogue.sh


user: #### Setup User Component
	@bash components/user.sh

shipping: #### Setup Shipping Component
	@bash components.catalogue.sh


payment: #### Setup Payment Component
	@bash components/payment.sh

frontend: #### Setup Frontend Component
	@bash components.frontend.sh


mysql: #### Setup Mysql Component
	@bash components/mysql.sh

redis: #### Setup Redis Component
	@bash components.redis.sh


rabbitmq: #### Setup RabbitMq Component
	@bash components/rabbitmq.sh

mongodb: #### Setup MongoDB Component
	@bash components.mongodb.sh