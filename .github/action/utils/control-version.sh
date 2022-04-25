#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# NOTE OF DEVELOPER: control step pending. example: control version. 
      # the correct artifact version in main is very important because represent tag release ending process. 
      # if exist version release then the artifact version is oblicatory incremente number. example in pom.xml or package.json.

# this shell is run in main branch, this branch hasn't snapshot version. control to remove by developers in code.
VERCHECK = $(echo ${env.VERSION,,} | grep -o '(snapshot)'); 

if [${VERCHECK,,}=="snapshot"] then
 echo "************************************************"
 echo "Error: Remove snapshot word in project version!."
 echo "************************************************"
 exit -1
if 


arg1=$(echo ${env.VERSION} | grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+') 
arg2=$(git describe --tags $(git rev-list --tags --max-count=1)) # NOTE of develop: test code! may be need reference repository first. find last tag version 
conditional='>'

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

testvercomp () {
    vercomp $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]
    then
        echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
        exit -1
    else
        echo "Pass: '$1 $op $2'"
    fi
}

# Run tests
# argument table format:
# testarg1   testarg2     expected_relationship
echo "The following tests should pass"
while read -r test
do
    testvercomp $test
done << EOF
1            1            =
2.1          2.2          <
3.0.4.10     3.0.4.2      >
4.08         4.08.01      <
3.2.1.9.8144 3.2          >
3.2          3.2.1.9.8144 <
1.2          2.1          <
2.1          1.2          >
5.6.7        5.6.7        =
1.01.1       1.1.1        =
1.1.1        1.01.1       =
1            1.0          =
1.0          1            =
1.0.2.0      1.0.2        =
1..0         1.0          =
1.0          1..0         =
EOF

echo "The following test should fail (test the tester)"
testvercomp ${arg1} ${arg2} ${conditional}


