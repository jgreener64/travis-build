module Travis
  class Build
    module Job
      class Test
        class JvmLanguage < Test
          class Config < Hashr
          end

          def install
            if uses_gradle?
              install_dependencies_with_gradle
            elsif uses_maven?
              install_dependencies_with_maven
            end
          end

          def script
            if uses_gradle?
              run_tests_with_gradle
            elsif uses_maven?
              run_tests_with_maven
            else
              run_tests_with_ant
            end
          end

          protected

          def uses_maven?
            @uses_maven ||= shell.file_exists?('pom.xml')
          end

          def uses_gradle?
            @uses_gradle ||= shell.file_exists?('build.gradle')
          end

          def install_dependencies_with_gradle
            "gradle assemble"
          end

          def install_dependencies_with_maven
            # otherwise mvn install will run tests
            # and we do not want it. Per suggestion from Charles Nutter. MK.
            "mvn install -DskipTests=true"
          end

          def run_tests_with_gradle
            "gradle check"
          end

          def run_tests_with_maven
            "mvn test"
          end

          def run_tests_with_ant
            "ant test"
          end
        end
      end
    end
  end
end
