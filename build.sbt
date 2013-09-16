name    := Kualigan Maven Plugins

version := "1.1.18-SNAPSHOT"


libraryDependencies ++= Seq(
    "org.apache.maven.plugins"        % "maven-compiler-plugin"        % "2.5.1",
    "org.apache.maven.plugin-testing" % "maven-plugin-testing-harness" % "2.0",
    "org.codehaus.plexus"             % "plexus-archiver"              % "2.0",
    "com.sun.codemodel"               % "codemodel"                    % "2.1",
    "org.apache.maven"                % "maven-plugin-api"             % "2.0",
    "org.apache.maven"                % "maven-project"                % "2.2.0",
    "org.apache.maven.plugin-tools"   % "maven-plugin-annotations"     % "2.0",
    "org.apache.maven"                % "maven-archiver"               % "2.0.1",
    "org.codehaus.plexus"             % "plexus-utils"                 % "3.0.2",
    "org.apache.maven"                % "maven-jetty-plugin"           % "6.6.1",
    "net.java.sezpoz"                 % "sezpoz"                       % "1.9",
    "org.apache.maven.plugins"        % "maven-archetype-plugin"       % "1.0-alpha-4",
    "org.codehaus.plexus"             % "plexus-interactivity-api"     % "1.0-alpha-4",
    "org.apache.maven.shared"         % "maven-invoker"                % "2.0.11",
    "commons-cli"                     % "commons-cli"                  % "1.2",
    "org.codehaus.plexus"             % "plexus-utils"                 % "3.0.2",
    "org.liquibase"                   % "liquibase-maven-plugin"       % "2.0.2",
    "org.kualigan.liquibase"          % "kualigan-lb-extensions"       % "1.0",
    "org.kualigan.liquibase"          % "kualigan-lb-ant"              % "1.0",
    "com.h2database"                  % "h2"                           % "1.0"
)
