date_stmp=$(date +%d%m%Y-%H%M%S)
JENKINS_HOME=/var/lib/jenkins
echo -e "\nCreating Jenkins_backup directory \n"
[ -d /tmp/jenkins_backup/bkpup/ ] || mkdir -p /tmp/jenkins_backup/bkpup/

echo -e "Copying the Plugin directory into Jenkins_backup directory \n"
cp -R ${JENKINS_HOME}/plugins /tmp/jenkins_backup/bkpup/

echo -e "Copying the userContent directory into Jenkins_backup directory \n"
cp -R ${JENKINS_HOME}/userContent /tmp/jenkins_backup/bkpup/

echo -e "Copying the ansible directory into Jenkins_backup directory \n"
[ -d ${JENKINS_HOME}/ansible ] && cp -R ${JENKINS_HOME}/ansible /tmp/jenkins_backup/bkpup/

echo -e "Copying the users directory into Jenkins_backup directory \n"
cp -R ${JENKINS_HOME}/users /tmp/jenkins_backup/bkpup/

echo -e "Copying the secrets directory into Jenkins_backup directory \n"
cp -R ${JENKINS_HOME}/secrets /tmp/jenkins_backup/bkpup/

echo -e "Copying the config files into Jenkins_backup directory \n"
for config_file in `ls -larth ${JENKINS_HOME}| grep ^- | awk '{ print $9 }'`
do
	cp -R ${JENKINS_HOME}/${config_file} /tmp/jenkins_backup/bkpup/
done

echo -e "Creating jobs dir into Jenkins_backup dir \n"
[ -d /tmp/jenkins_backup/bkpup/jobs ] || mkdir -p /tmp/jenkins_backup/bkpup/jobs

for dirname in `sudo ls -1 ${JENKINS_HOME}/jobs`
do
    echo "Selected job is: ${dirname} \n"
    #[ -d /tmp/jenkins_backup/bkpup/${dirname} ] || mkdir -p /tmp/jenkins_backup/bkpup/${dirname}
    #rsync -R ${JENKINS_HOME}/jobs/${dirname} /tmp/jenkins_backup/bkpup/${dirname}

    echo -e "Creating ${dirname} job dir into Jenkins_backup dir \n"
    sudo rsync -avh --progress ${JENKINS_HOME}/jobs/${dirname} /tmp/jenkins_backup/bkpup/jobs/ --exclude builds
done

echo -e "Compressing the Jenkins_backup \n"
tar -cvf /tmp/jenkins_backup/jenkins_backup_${date_stmp}.tar -C /tmp/jenkins_backup/bkpup/ .



