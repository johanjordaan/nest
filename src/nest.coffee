fs = require('fs')
path = require('path')
_ = require('underscore')
prompt = require('prompt')
mkdirp = require('mkdirp')
ncp = require('ncp').ncp


# Print the help message
# 
print_help = () ->
  console.log 'Usage : nest <command>'
  console.log 'Valid commands :'
  console.log '  init      - Initialised a nest directory'
  console.log '  enable    - Enable the site'
  console.log '  disable   - Disable the site'

# Get the command from the command line
#
get_command = (argv) ->
  args = argv.slice(2)
  if args.length <= 0
    return null
  else
    return { command:args[0],args:args.slice(1) } 

# Render a template from the soure to the dest using the provided values
#
render_template = (source,dest,values) ->
  mkdirp path.dirname(dest), (err) ->
    fs.readFile source, 'utf8', (err, data) ->
      if err? 
        throw err
      template = _.template(data)
      concrete = template(values)

      fs.writeFile dest, concrete, 'utf8', (err) ->
        if err? 
          throw err   
        console.log "Written [#{dest}]" 

# Gather input from the user
# 
gather_input = (cb) ->
  prompt.start()

  name = ""
  if prompt.history('name')?
    name  = prompt.history('name').value

  prompt.get [ { 
      name : 'name'
      default : "Happy"
    }
  ,'description','author','email','git_site','site_name','site_node_port'], (err,result) ->
    result.year = new Date().getFullYear()
    cb(result)


copy_file = (source,dest) ->
  mkdirp path.dirname(dest), (err) ->
    if err?
      throw err
    fs.readFile source, 'utf8', (err,data) ->
      if err?
        throw err
      fs.writeFile dest, data, 'utf8', (err) ->
        if err?
          throw err
        console.log "Written [#{dest}]" 


isEmpty = (dir,cb) ->
  fs.stat dir, (err,stat) ->
    if err?
      cb true     # A non existant dir is valid since it will be created
      return 

    if stat.isDirectory()
      fs.readdir dir, (err, items) ->
        if err?
          cb true     # Is this valid??
        else
          cb !items || !items.length
    else
      cb false    # It is a file and cannot be the target of init

# Initialise the provided directory as a nest project
#
init = (dir) ->
  isEmpty dir, (empty) ->
    if !empty
      console.log "Cannot init a non-empty directory..."
    else  
      gather_input (values) ->
        console.log "Initialising [#{dir}]"
        # Standard dev environment files
        #
        render_template path.join(__dirname,'nginx.conf.template'), path.join(dir,'nginx.conf'), values 
        render_template path.join(__dirname,'bower.json.template'), path.join(dir,'bower.json'), values 
        render_template path.join(__dirname,'package.json.template'), path.join(dir,'package.json'), values   
        render_template path.join(__dirname,'README.md.template'), path.join(dir,'README.md'), values  
        render_template path.join(__dirname,'LICENSE.template'), path.join(dir,'LICENSE'), values
        render_template path.join(__dirname,'.gitignore.template'), path.join(dir,'.gitignore')
        copy_file path.join(__dirname,'gruntfile.coffee'), path.join(dir,'gruntfile.coffee')

        # Demo site files
        #
        render_template path.join(__dirname,'src','site','server.coffee'), path.join(dir,'src','site','server.coffee'), values
        ncp path.join(__dirname,'src'),path.join(dir,'src'), (err) ->
          if err
            throw err
          else 
            console.log 'Done...'



# Get the command to execute
#
cmd  = get_command(process.argv)
if !cmd? or cmd.command not in ['init']
  print_help()
  process.exit()

if cmd.command == 'init'
  dir = process.cwd()
  if cmd.args.length > 0 
    dir = cmd.args[0]
  init(dir)
