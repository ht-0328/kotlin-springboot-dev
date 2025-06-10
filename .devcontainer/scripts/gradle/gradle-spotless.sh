#!/bin/bash

cd "$(dirname "$0")/../../../projects/kotlin-spring-boot-app" || exit

./gradlew spotlessApply
