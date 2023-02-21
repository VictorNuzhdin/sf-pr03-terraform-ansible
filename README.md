# sf-pr03-terraform-ansible
For Skill Factory study project (PR03)


--КРАТКАЯ ИНСТРУКЦИЯ

01. Размещаем содержимое каталогов [terraform](terraform) и [ansible](ansible) в свое настроенное Terraform и Ansible окружение;

02. Создаем облачные ресурсы Yandex.Cloud с помощью Terraform конфигурации [terraform/main.tf](/terraform/main.tf)
    и последовательно выполняемых команд "terraform validate", "terraform plan", "terraform apply";
    В результате получаем сформированный локальный Terraform state
    и Terraform output переменные описанные в конфигурации [terraform/output.tf](/terraform/output.tf)
    В частности получаем публичные адреса созданных ВМ
    которые изображены на скриншоте в каталоге [_screens](_screens):
    [виртуальные машины](_screens/yandex-cloud__3_compute-instances__20230221_181240.png)


03. Подключаемся к управляющему хосту VM1 (Ubuntu 20.04) по ssh, создаем пользователя "devops" с sudo правами;
04. Подключаемся к управляемому хосту VM2 (Ubuntu 20.04) по ssh, создаем пользователя "devops" с sudo правами;
05. Подключаемся к управляемому хосту VM3 (CentOS Stream 8) по ssh, создаем пользователя "devops" с sudo правами;

06. Настраиваем авторизацию по ssh-ключам с хоста VM1 на хосты VM2, VM3 без запроса парольной фразы;

07. Переносим на VM1 конфигурацию из каталога [ansible](/ansible);

08. Открывам inventory файл [ansible/hosts](/ansible/hosts) и вносим в него публичные ip-адреса созданных в (2) ресурсов;

09. Выполняем проверку ssh-доступности управляющих хостов с помощью команды:

    $ ansible all -m ping

    при этом должен быть получен ответ вида:

<pre>
158.160.21.37 | SUCCESS => {
        "ansible_facts": {
                "discovered_interpreter_python": "/usr/bin/python3"
        },
        "changed": false,
        "ping": "pong"
}
158.160.12.167 | SUCCESS => {
        "ansible_facts": {
                "discovered_interpreter_python": "/usr/bin/python3"
        },
        "changed": false,
        "ping": "pong"
}
51.250.111.8 | SUCCESS => {
        "ansible_facts": {
                "discovered_interpreter_python": "/usr/libexec/platform-python"
        },
        "changed": false,
        "ping": "pong"
}
</pre>


10. Применяем Ansible роли "postrgresql" и "docker" через плейбук /playbooks/deploy_docker_postgre.yml
    к группам "database", "app", "web" управляемых хостов описанных в inventory файле /ansible/hosts
    с помощью команды:

        $ ansible-playbook /etc/ansible/playbooks/deploy_docker_postgre.yml

    в результате должен быть получен ответ вида:

<pre>
PLAY [app] ************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************
ok: [158.160.21.37]
ok: [51.250.111.8]

TASK [docker : Ubuntu(20) - Install aptitude] *************************************************************************************
skipping: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Ubuntu(20) - Install required system packages] *********************************************************************
skipping: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Ubuntu(20) - Add Docker GPG apt Key] *******************************************************************************
skipping: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Ubuntu(20) - Add Docker Repository] ********************************************************************************
skipping: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Ubuntu(20) - Update apt and install docker-ce] *********************************************************************
skipping: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Ubuntu(20) - Install Docker Module for Python] *********************************************************************
skipping: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Ubuntu(20) - Add devops user to docker group] **********************************************************************
skipping: [51.250.111.8]
changed: [158.160.21.37]

TASK [docker : Ubuntu(20) - Enable and restart Docker service] ********************************************************************
skipping: [51.250.111.8]
changed: [158.160.21.37]

TASK [docker : CentOS(8) - Enable EPEL Repository] ********************************************************************************
skipping: [158.160.21.37]
ok: [51.250.111.8]

TASK [docker : CentOS(8) - Add Docker repo] ***************************************************************************************
skipping: [158.160.21.37]
ok: [51.250.111.8]

TASK [docker : CentOS(8) - Install docker-ce] *************************************************************************************
skipping: [158.160.21.37]
ok: [51.250.111.8]

TASK [docker : CentOS(8) - Add devops user to docker group] ***********************************************************************
skipping: [158.160.21.37]
changed: [51.250.111.8]

TASK [docker : CentOS(8) - Enable and restart Docker service] *********************************************************************
skipping: [158.160.21.37]
changed: [51.250.111.8]

TASK [docker : Debug - Check Docker service is Exists] ****************************************************************************
ok: [51.250.111.8]
ok: [158.160.21.37]

TASK [docker : Debug - Get OS version] ********************************************************************************************
changed: [158.160.21.37]
changed: [51.250.111.8]

TASK [docker : Debug - Docker get version to stdout] ******************************************************************************
changed: [51.250.111.8]
changed: [158.160.21.37]

TASK [docker : Debug - Docker run hello-world] ************************************************************************************
changed: [158.160.21.37]
changed: [51.250.111.8]

TASK [docker : debug] *************************************************************************************************************
ok: [158.160.21.37] => {
        "os_version.stdout_lines": [
                "Ubuntu 20.04.5 LTS"
        ]
}
ok: [51.250.111.8] => {
        "os_version.stdout_lines": [
                "CentOS Stream 8"
        ]
}

TASK [docker : debug] *************************************************************************************************************
ok: [158.160.21.37] => {
        "docker_out1.stdout_lines": [
                "Docker version 23.0.1, build a5ee5b1"
        ]
}
ok: [51.250.111.8] => {
        "docker_out1.stdout_lines": [
                "Docker version 23.0.1, build a5ee5b1"
        ]
}

TASK [docker : debug] *************************************************************************************************************
ok: [158.160.21.37] => {
        "docker_out2.stdout_lines": [
                "Hello from Docker!"
        ]
}
ok: [51.250.111.8] => {
        "docker_out2.stdout_lines": [
                "Hello from Docker!"
        ]
}

PLAY [database] *******************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************
ok: [158.160.12.167]

TASK [postgresql : fail] **********************************************************************************************************
skipping: [158.160.12.167]

TASK [postgresql : Print test vars from inventory] ********************************************************************************
ok: [158.160.12.167] => {
        "msg": [
                "INFO: PostgreSQL version to be installed..: 13",
                "INFO: PostgreSQL new database path will be: /opt/databases/postgresql"
        ]
}

TASK [postgresql : Ubuntu(20) - Import the GPG signing key for the postgresql repository] *****************************************
changed: [158.160.12.167]

TASK [postgresql : Ubuntu(20) - Add postgresql repository to local apt db] ********************************************************
changed: [158.160.12.167]

TASK [postgresql : Ubuntu(20) - Update local packages cache before install] *******************************************************
ok: [158.160.12.167]

TASK [postgresql : Ubuntu(20) - Install PostgreSQL 13] ****************************************************************************
changed: [158.160.12.167]

TASK [postgresql : Ubuntu(20) - Open firewall port 5432 tcp] **********************************************************************
changed: [158.160.12.167]

TASK [postgresql : PostgreSQL - Create new directory for databases] ***************************************************************
changed: [158.160.12.167]

TASK [postgresql : PostgreSQL - Apply recursive permissions to new database directory] ********************************************
changed: [158.160.12.167]

TASK [postgresql : Debug - Print new dtabase path param] **************************************************************************
ok: [158.160.12.167] => {
        "msg": "INFO - PostgreSQL new database path param data_directory = '/opt/databases/postgresql/13/main'"
}

TASK [postgresql : PostgreSQL - Set conf param (data_directory)] ******************************************************************
changed: [158.160.12.167]

TASK [postgresql : PostgreSQL - Set conf param (listen_addresses)] ****************************************************************
changed: [158.160.12.167]

TASK [postgresql : PostgreSQL - Copy system databases to new location] ************************************************************
changed: [158.160.12.167]

TASK [postgresql : Debug - Get OS version (Debian like)] **************************************************************************
changed: [158.160.12.167]

TASK [postgresql : Debug - Get PostgreSQL service status] *************************************************************************
changed: [158.160.12.167]

TASK [postgresql : Debug - Get PostgreSQL installed version (from file)] **********************************************************
changed: [158.160.12.167]

TASK [postgresql : Debug - Get PostgreSQL installed version (from bin)] ***********************************************************
changed: [158.160.12.167]

TASK [postgresql : debug] *********************************************************************************************************
ok: [158.160.12.167] => {
        "os_version.stdout_lines": [
                "Ubuntu 20.04.5 LTS"
        ]
}

TASK [postgresql : debug] *********************************************************************************************************
ok: [158.160.12.167] => {
        "pg_service_status.stdout_lines": [
                "     Active: active (exited) since Tue 2023-02-21 11:26:14 UTC; 52s ago"
        ]
}

TASK [postgresql : debug] *********************************************************************************************************
ok: [158.160.12.167] => {
        "pg_installed_version_from_file.stdout_lines": [
                "13"
        ]
}

TASK [postgresql : debug] *********************************************************************************************************
ok: [158.160.12.167] => {
        "pg_installed_version_from_bin.stdout_lines": [
                "postgres (PostgreSQL) 13.10 (Ubuntu 13.10-1.pgdg20.04+1)"
        ]
}

RUNNING HANDLER [postgresql : postgresql_restart] *********************************************************************************
changed: [158.160.12.167]

PLAY RECAP ************************************************************************************************************************
158.160.12.167             : ok=22   changed=14   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
158.160.21.37              : ok=16   changed=5    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
51.250.111.8               : ok=13   changed=5    unreachable=0    failed=0    skipped=8    rescued=0    ignored=0
</pre>


11. Далее последовательно подключаясь к хостам VM1,VM2,VM3 выполняем серию тестов для проверки результата
    установки ПО на сервера (справа за двойной решоткой показан результат вывода):
<pre>
..проверяем результат на [VM1] (Ubuntu 20)
  *этот хост входит в группу [database] поэтому на нем должен быть установлена PosgreSQL
   указанной в inventory версии (13) и измененным каталогом размещения баз данных (/opt/databases/postgresql)

    $ ssh -i ~/.ssh/id_ed25519 ubuntu@158.160.12.167            ## подключаемся к VM1
    $ su devops
    $ whoami                                                    ## devops
    $ cd ~; pwd                                                 ## /home/devops

    $ systemctl status postgresql | grep Active                 ## Active: active (exited) since Tue 2023-02-21 11:27:14 UTC; 5min ago
    $ /usr/lib/postgresql/13/bin/postgres -V                    ## postgres (PostgreSQL) 13.10 (Ubuntu 13.10-1.pgdg20.04+1)
    $ sudo ls -la /opt/databases/postgresql/13/main/PG_VERSION  ## -rw------- 1 postgres postgres 3 Feb 21 11:26 /opt/databases/postgresql/13/main/PG_VERSION

    $ sudo -u postgres psql -c "SELECT version();" | grep PostgreSQL     ## PostgreSQL 13.10 (Ubuntu 13.10-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
    $ sudo -u postgres psql -c "SHOW data_directory;" | grep postgresql  ## /opt/databases/postgresql/13/main

..проверяем результат на [VM2] (Ubuntu 20)
  *этот хост входит в группу [app] поэтому на нем должен быть установлен Docker

    $ ssh -i ~/.ssh/id_ed25519 ubuntu@158.160.12.167            ## подключаемся к VM1 (Ubuntu 22.04) с авторизацией по ssh-ключу, логину и паролю
    $ su devops
    $ whoami                                                                                                                                     ## devops
    $ cd ~; pwd                                                                                                                                  ## /home/devops

    $ ssh devops@158.160.21.37                                                                                                   ## подключаемся к VM2 (Ubuntu 22.04) с авторизацией по ssh-ключу
    $ curl 2ip.ru                                                                                                                                ## 158.160.21.37
    $ hostname                                                                                                                                   ## ubuntu2
    $ whoami                                                                                                                                     ## devops

    $ hostnamectl | grep System | awk '{print $3" "$4" "$5}'    ## Ubuntu 20.04.5 LTS
    $ docker --version                                                                                                                  ## Docker version 23.0.1, build a5ee5b1
    $ systemctl status docker | grep Active                     ## Active: active (running) since Tue 2023-02-21 11:23:01 UTC; 28min ago
    $ docker run hello-world | grep Hello                       ## Hello from Docker!
    $ exit                                                                                                                              ## logout. Connection to 158.160.21.37 closed.

..проверяем результат на [VM3] (CentOS 8)
  *этот хост входит в группу [app] поэтому на нем должен быть установлен Docker

    $ ssh devops@51.250.111.8                                                                                                       ## подключаемся к VM3 (CentOS Stream 8) с авторизацией по ssh-ключу
    $ curl 2ip.ru                                                                                                                       ## 51.250.111.8
    $ hostname                                                                                                                          ## centos8
    $ whoami                                                                                                                            ## devops

    $ hostnamectl | grep System | awk '{print $3" "$4" "$5}'     ## CentOS Stream 8
    $ docker --version                                                                                                                  ## Docker version 23.0.1, build a5ee5b1
    $ systemctl status docker | grep Active                      ## Active: active (running) since Tue 2023-02-21 11:23:22 UTC; 32min ago
    $ docker run hello-world | grep Hello                        ## Hello from Docker!
    $ exit                                                                                                                              ## logout. Connection to 51.250.111.8 closed.
</pre>

--ПРИМЕЧАНИЕ:
Кривое оформление - это претензии к GitHub - они до сих пор не могут добавить обычный машинописный (console или typewriter) шрифт
чтобы при копипасте из текстового файла ничего не сьезжало!
Про язык разметки GitHub знаю и считают это ПОЛНЫМ бредом размечать простой текст специальными тегами!

