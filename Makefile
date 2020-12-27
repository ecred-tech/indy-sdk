pool_ip := 192.168.1.6

build-node:
	@echo ---- building local indy node ----
	docker build --build-arg pool_ip=$(pool_ip) -f ci/indy-pool.dockerfile -t indy_pool .

run-node:
	@echo ---- running local indy node ----
	docker run --rm --name indy_pool -itd -p $(pool_ip):9701-9708:9701-9708 indy_pool

run-test:
	@echo ---- running indy-sdk integration test ----
	cd libindy; RUST_TEST_THREADS=1 TEST_POOL_IP=$(pool_ip) cargo test
