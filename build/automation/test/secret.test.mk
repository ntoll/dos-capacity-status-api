test-secret: \
	test-secret-setup \
	test-secret-random \
	test-secret-create \
	test-secret-fetch \
	test-secret-fetch-and-export-variables \
	test-secret-teardown

test-secret-setup:
	make docker-config
	make docker-compose-start YML=$(TEST_DIR)/docker-compose.localstack.yml
	make docker-image NAME=tools

test-secret-teardown:
	make docker-compose-stop YML=$(TEST_DIR)/docker-compose.localstack.yml
	rm -rf $(TMP_DIR)/localstack

# ==============================================================================

test-secret-random:
	# act
	secret=$$(make secret-random LENGTH=128)
	# assert
	mk_test $(@) 128 -eq $$(expr length "$$secret")

test-secret-create:
	# arrange
	export DB_HOST=localhost
	export DB_PORT=5432
	# act
	make secret-create NAME=service/deployment-$(@) VARS=DB_HOST,DB_PORT
	# assert
	secret=$$(make secret-fetch NAME=service/deployment-$(@))
	mk_test $(@) '{"DB_HOST":"localhost","DB_PORT":"5432"}' = $$secret

test-secret-fetch:
	# arrange
	export DB_USERNAME=admin
	export DB_PASSWORD=secret
	# act
	make secret-create NAME=service/deployment-$(@) VARS=DB_USERNAME,DB_PASSWORD
	secret=$$(make secret-fetch NAME=service/deployment-$(@))
	# assert
	mk_test $(@) '{"DB_USERNAME":"admin","DB_PASSWORD":"secret"}' = $$secret

test-secret-fetch-and-export-variables:
	# arrange
	export DB_HOST=localhost
	export DB_PORT=5432
	export DB_NAME=test
	export DB_USERNAME=admin
	export DB_PASSWORD=secret
	make secret-create NAME=service/deployment-$(@) VARS=DB_HOST,DB_PORT,DB_NAME,DB_USERNAME,DB_PASSWORD
	# act
	secret=$$(make secret-fetch-and-export-variables NAME=service/deployment-$(@))
	# assert
	mk_test $(@) 5 -eq $$(echo "$$secret" | grep DB_ | wc -l)
	mk_test "$(@) terraform" 5 -eq $$(echo "$$secret" | grep TF_VAR_db_ | wc -l)
