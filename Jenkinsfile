pipeline {
	agent any
	stages {
			stage ('Checkout') {
			steps {
				echo "Do the SVN/GIT Checkout"
				}
			}
			
			stage ('Build') {
			steps {
				echo "Build by using ANT/MAVEN"
				}
			}
			
			stage ('Test') {
			steps {
				echo "Do the test by using Junit/Selenium"
				}
			}
			
			stage ('QA') {
			steps {
				echo "Do the Qa testing"
				}
			}
			
			stage ('deploy') {
			steps {
				echo "Deploy the artifacts respectuve servers by using Ansible/chef/docker...etc"
				}
			}
			
			stage ('Monitor') {
			steps {
				echo "Monitot the application by using sonarcube/Javamelody"
				}
			}
		}
}	

This is cpoied from master.
