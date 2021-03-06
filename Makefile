postgres:
	sudo docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14.4-alpine

createdb:
	sudo docker exec -t postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	sudo docker exec -t postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -build_flags=--mod=mod -package mockdb -destination db/mock/store.go github.com/dbsSensei/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown