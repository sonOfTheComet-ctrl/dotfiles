if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx JAVA_HOME /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
set -gx PATH $JAVA_HOME/bin $PATH
set -gx PATH ~/.local/bin $PATH
