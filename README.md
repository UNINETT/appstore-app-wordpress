# Fast 'n ugly Dataporten + Wordpress deploy

This is a proof of concept.  Do not use it to store *ANY* data you'd like to hold on.  
This **WILL** shave your cat and then eat it.

Ingredients:

- Docker
- Dataporten application credentials (obtain from dashboard.dataporten.no)

How to make:

1. Create a file env.txt with contents somewhat similar to:

		BASEURL=http://localhost:8080
		DATAPORTEN_CLIENTID=00000000-0000-0000-0000-000000000000
		DATAPORTEN_CLIENTSECRET=00000000-0000-0000-0000-000000000000
		DBHOST=wp-mysql
		DBNAME=wordpress
		DBUSER=root
		DBPASS=

2. Then start the whole rigamarole with:

		docker rm --force wp-mysql
		docker run --name wp-mysql -e MYSQL_ROOT_HOST=% -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -d mysql/mysql-server
		docker build -t wp .
		docker run -p 8080:6080 --env-file env.txt -it --link wp-mysql:mysql wp

3. Using these commands, you should now be able to log in to http://localhost:8080/wp-admin/
