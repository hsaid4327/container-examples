#!/bin/bash

echo "###############################################################################"
echo "#  MAKE SURE YOU ARE LOGGED IN:                                               #"
echo "#  $ oc login http://<api-url>                                                #"
echo "###############################################################################"

function usage() {
 echo
    echo "Usage:"
    echo " $0 [command] [options]"
    echo " $0 --help"
    echo
    echo "Example:"
    echo " $0 deploy --project-suffix mydemo --appname appname --repo-url repourl --repo-reference master --context-dir mydir"

    echo " $0 delete --project-suffix mydemo"
    echo
    echo "COMMANDS:"
    echo "   deploy                   Set up the demo projects and deploy demo apps"
    echo "   delete                   Clean up and remove demo projects and objects"
    echo
    echo "OPTIONS:"


    echo "   --app-name                required     application name for the deployment artifact and openshift resources."
    echo "   --repo-url                 required    The location url of the git repository of the application source code"
    echo "   --repo-reference           required    The branch of the source code repository"
    echo "   --project-suffix [suffix]  Optional    Suffix to be added to demo project names e.g. ci-SUFFIX. If empty, user will be used as suffix"

}


ARG_COMMAND=
ARG_PROJECT_SUFFIX=
ARG_REPO_URL=
ARG_REPO_REF=
ARG_APP_NAME=
ARG_CONTEXT_DIR=
NUM_ARGS=$#

echo "The number of shell arguments is $NUM_ARGS"

while :; do
    case $1 in
        deploy)
            ARG_COMMAND=deploy
            if [ "$NUM_ARGS" -lt 5 ]; then
              printf 'ERROR: "--the number of arguments cannot be less than 4 for deploy command" \n' >&2
              usage
              exit 255
            fi
            ;;
        delete)
            ARG_COMMAND=delete
            ;;


        --project-suffix)
            if [ -n "$2" ]; then
                ARG_PROJECT_SUFFIX=$2
                shift
            else
                printf 'ERROR: "--project-suffix" requires a non-empty value.\n' >&2
                usage
                exit 255
            fi
            ;;
        --app-name)
            if [ -n "$2" ]; then
                ARG_APP_NAME=$2
                shift
            else
                printf 'ERROR: "--arg-app-name" requires a non-empty value.\n' >&2
                usage
                exit 255
            fi
            ;;

          --repo-url)
            if [ -n "$2" ]; then
                ARG_REPO_URL=$2
                shift
            else
                printf 'ERROR: "--repo-url" requires a non-empty value.\n' >&2
                usage
                exit 255
            fi
            ;;
         --repo-reference)
            if [ -n "$2" ]; then
                ARG_REPO_REF=$2
                shift
            else
                printf 'ERROR: "--repo-reference" requires a non-empty value.\n' >&2
                usage
                exit 255
            fi
            ;;
            --context-dir)
               if [ -n "$2" ]; then
                   ARG_CONTEXT_DIR=$2
                   shift

               ;;

        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            shift
            ;;
        *) # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done
 if [ -z $ARG_PROJECT_SUFFIX ]; then
    usage
    exit 255
 fi
DEV_PROJECT=dev-$ARG_PROJECT_SUFFIX
STAGE_PROJECT=stage-$ARG_PROJECT_SUFFIX
CICD_PROJECT=avaya-cicd
APP_NAME=$ARG_APP_NAME
REPO_URL=$ARG_REPO_URL
REPO_REF=$ARG_REPO_REF
CONTEXT_DIR=$ARG_CONTEXT_DIR

template="cisco-cicd-template.yaml"


function setup_projects() {
  echo_header "*****************  Setting up projects  *******************************"
  oc new-project  $DEV_PROJECT   --display-name="$ARG_PROJECT_SUFFIX - Dev"
  oc  new-project $STAGE_PROJECT --display-name="$ARG_PROJECT_SUFFIX - Stage"
  cicdCreated=$(oc projects | grep $CICD_PROJECT)
  if [ -z "$cicdCreated" ]; then
    oc new-project $CICD_PROJECT --display-name="CI/CD"
  else
     oc project $CICD_PROJECT
  fi

  sleep 2

  oc policy add-role-to-group edit system:serviceaccounts:$CICD_PROJECT -n $DEV_PROJECT
  oc policy add-role-to-group edit system:serviceaccounts:$CICD_PROJECT -n $STAGE_PROJECT
  oc policy add-role-to-group edit system:serviceaccounts:$STAGE_PROJECT -n $DEV_PROJECT

  echo "Using template $template"
  echo_header "processing template"
  oc process -f $template -p DEV_PROJECT=$DEV_PROJECT -p STAGE_PROJECT=$STAGE_PROJECT -p CICD_PROJECT=$CICD_PROJECT -p APP_NAME=$APP_NAME  -p REPO_URL=$REPO_URL -p REPO_REF=$REPO_REF -p CONTEXT_DIR=$CONTEXT_DIR | oc create -f - -n $CICD_PROJECT
}

function setup_applications() {
    echo_header "Setting up Openshift application resources"
    oc new-app jenkins-persistent -n $CICD_PROJECT
    sleep 2



}

function echo_header() {
  echo
  echo "########################################################################"
  echo $1
  echo "########################################################################"
}




START=`date +%s`


echo_header "OpenShift CI/CD Demo ($(date))"

case "$ARG_COMMAND" in
    delete)
        echo "Delete demo..."
        oc delete project $DEV_PROJECT $STAGE_PROJECT $CICD_PROJECT
        echo
        echo "Delete completed successfully!"
        ;;


    deploy)
        echo "Deploying demo..."
        setup_projects
        echo
        echo "project setup completed successfully!"
        echo "setting up application artifacts ......."
        setup_applications
        echo "setting up applications completed successfully"
        ;;

    *)
        echo "Invalid command specified: '$ARG_COMMAND'"
        usage
        ;;
  esac


END=`date +%s`
echo "(Completed in $(( ($END - $START)/60 )) min $(( ($END - $START)%60 )) sec)"
