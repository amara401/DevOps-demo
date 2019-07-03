pipeline {
	agent any
	stages {
			stage ('Checkout') {
				echo "Do the SVN/GIT Checkout"
			}
			
			stage ('Build') {
				echo "Build by using ANT/MAVEN"
			}
			
			stage ('Test') {
				echo "Do the test by using Junit/Selenium"
			}
			
			stage {'QA'} {
				echo "Do the Qa testing"
			}
			
			stage ('deploy') {
				echo "Deploy the artifacts respectuve servers by using Ansible/chef/docker...etc"
			}
			
			stage ('Monitor') {
				echo "Monitot the application by using sonarcube/Javamelody"
			}
		}
}
