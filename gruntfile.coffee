module.exports = (grunt) ->

  grunt.initConfig
    pkg : grunt.file.readJSON('package.json')
    
    concurrent:
      dev:
        tasks: ['nodemon','watch']
        options:
          logConcurrentOutput: true

    uglify :
      options :
        banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
    
      build : 
        src : 'dist/<%= pkg.name %>.js',
        dest: 'dist/<%= pkg.name %>.min.js'

    coffee: 
      singles:
        options:
          bare : true
        expand: true,
        cwd: './src',
        src: ['**/*.coffee'],
        dest: './',
        ext: '.js'
        extDot : 'last'
      

    mochaTest:
      test:
        options:
          reporter: 'dot'
        src: ['test/**/*.js']


    nodemon:
      dev:
        script: 'site/server.js'
        #options:
        #  watch : ['server']

    less:
      all:
        files: [
          { expand: true,cwd:'src/',src: ['**/*.less'], dest: './' , ext:'.css'}
        ]  
  
    copy:
      html:
        files: [
          { expand: true, cwd:'src/',src: ['**/*.html'], dest: './' }
        ]  

    watch:
      coffee:
        files: 'src/**/*.coffee'
        tasks: ['coffee']
        options: 
          debounceDelay: 250
      less:
        files: 'src/**/*.less'
        tasks: ['less']
        options: 
          debounceDelay: 250
      html:
        files: 'src/**/*.html'
        tasks: ['copy:html']
        options: 
          debounceDelay: 250




  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-nodemon')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-concurrent')
  
  grunt.registerTask('default', ['coffee:singles','less:all','copy:html','mochaTest'])
  grunt.registerTask('run', ['default','nodemon:dev'])




