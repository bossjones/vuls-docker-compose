version:
	docker run  --rm  vuls/go-cve-dictionary version
	docker run  --rm  vuls/goval-dictionary version
	docker run  --rm  vuls/gost version
	docker run  --rm  vuls/go-exploitdb version
	docker run  --rm  vuls/go-msfdb version
	docker run  --rm  vuls/go-kev version
	docker run  --rm  vuls/vuls -v
	
fetch:
# dictonary
	docker run --rm -it \
    -v $PWD:/go-cve-dictionary \
    -v $PWD/go-cve-dictionary-log:/var/log/go-cve-dictionary \
    vuls/go-cve-dictionary fetch nvd
# goval
    docker run --rm -it \
    -v $PWD:/goval-dictionary \
    -v $PWD/goval-dictionary-log:/var/log/goval-dictionary \
    vuls/goval-dictionary fetch redhat 5 6 7 8
    
    docker run --rm -it \
    -v $PWD:/goval-dictionary \
    -v $PWD/goval-dictionary-log:/var/log/goval-dictionary \
    vuls/goval-dictionary fetch debian 7 8 9 10 11
    
    docker run --rm -it \
    -v $PWD:/goval-dictionary \
    -v $PWD/goval-dictionary-log:/var/log/goval-dictionary \
    vuls/goval-dictionary fetch ubuntu 14 16 18 19 20 21 22
# gost
    docker run --rm -i \
    -v $PWD:/gost \
    -v $PWD/gost-log:/var/log/gost \
    vuls/gost fetch redhat
    
    docker run --rm -i \
    -v $PWD:/gost \
    -v $PWD/gost-log:/var/log/gost \
    vuls/gost fetch debian
    
    docker run --rm -i \
    -v $PWD:/gost \
    -v $PWD/gost-log:/var/log/gost \
    vuls/gost fetch ubuntu
    
# exploitdb
    docker run --rm -i \
    -v $PWD:/go-exploitdb \
    -v $PWD/go-exploitdb-log:/var/log/go-exploitdb \
    vuls/go-exploitdb fetch exploitdb
	
	docker run --rm -i \
    -v $PWD:/go-exploitdb \
    -v $PWD/go-exploitdb-log:/var/log/go-exploitdb \
    vuls/go-exploitdb fetch awesomepoc
	
	docker run --rm -i \
    -v $PWD:/go-exploitdb \
    -v $PWD/go-exploitdb-log:/var/log/go-exploitdb \
    vuls/go-exploitdb fetch githubrepos
	
	docker run --rm -i \
    -v $PWD:/go-exploitdb \
    -v $PWD/go-exploitdb-log:/var/log/go-exploitdb \
    vuls/go-exploitdb fetch inthewild
    
	docker run --rm -i \
    -v $PWD:/go-msfdb \
    -v $PWD/go-msfdb-log:/var/log/go-msfdb \
    vuls/go-msfdb fetch msfdb
    
    docker run --rm -i \
    -v $PWD:/go-kev \
    -v $PWD/go-kev-log:/var/log/go-kev \
    vuls/go-kev fetch kevuln
    
configtest:
	docker run --rm -it\
    -v ~/.ssh:/root/.ssh:ro \
    -v $PWD:/vuls \
    -v $PWD/vuls-log:/var/log/vuls \
    vuls/vuls configtest \
    -config=./config.toml # path to config.toml in docker
    
scan:
# path to config.toml in docker
    docker run --rm -it \
    -v ~/.ssh:/root/.ssh:ro \
    -v $PWD:/vuls \
    -v $PWD/vuls-log:/var/log/vuls \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    vuls/vuls scan \
    -config=./config.toml 

report:
# path to config.toml in docker
	docker run --rm -it \
    -v ~/.ssh:/root/.ssh:ro \
    -v $PWD:/vuls \
    -v $PWD/vuls-log:/var/log/vuls \
    -v /etc/localtime:/etc/localtime:ro \
    vuls/vuls report \
    -format-list \
    -config=./config.toml 

tui:
# path to config.toml in docker
	docker run --rm -it \
    -v ~/.ssh:/root/.ssh:ro \
    -v $PWD:/vuls \
    -v $PWD/vuls-log:/var/log/vuls \
    -v /etc/localtime:/etc/localtime:ro \
    vuls/vuls tui \
    -config=./config.toml 
    
config:
	cp -av example-config.toml config.toml