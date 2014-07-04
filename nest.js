var cmd, copy_file, dir, fs, gather_input, get_command, init, isEmpty, mkdirp, ncp, path, print_help, prompt, render_template, _, _ref;

fs = require('fs');

path = require('path');

_ = require('underscore');

prompt = require('prompt');

mkdirp = require('mkdirp');

ncp = require('ncp').ncp;

print_help = function() {
  console.log('Usage : nest <command>');
  console.log('Valid commands :');
  console.log('  init      - Initialised a nest directory');
  console.log('  enable    - Enable the site');
  return console.log('  disable   - Disable the site');
};

get_command = function(argv) {
  var args;
  args = argv.slice(2);
  if (args.length <= 0) {
    return null;
  } else {
    return {
      command: args[0],
      args: args.slice(1)
    };
  }
};

render_template = function(source, dest, values) {
  return mkdirp(path.dirname(dest), function(err) {
    return fs.readFile(source, 'utf8', function(err, data) {
      var concrete, template;
      if (err != null) {
        throw err;
      }
      template = _.template(data);
      concrete = template(values);
      return fs.writeFile(dest, concrete, 'utf8', function(err) {
        if (err != null) {
          throw err;
        }
        return console.log("Written [" + dest + "]");
      });
    });
  });
};

gather_input = function(cb) {
  var name;
  prompt.start();
  name = "";
  if (prompt.history('name') != null) {
    name = prompt.history('name').value;
  }
  return prompt.get([
    {
      name: 'name',
      "default": "Happy"
    }, 'description', 'author', 'email', 'git_site', 'site_name', 'site_node_port'
  ], function(err, result) {
    result.year = new Date().getFullYear();
    return cb(result);
  });
};

copy_file = function(source, dest) {
  return mkdirp(path.dirname(dest), function(err) {
    if (err != null) {
      throw err;
    }
    return fs.readFile(source, 'utf8', function(err, data) {
      if (err != null) {
        throw err;
      }
      return fs.writeFile(dest, data, 'utf8', function(err) {
        if (err != null) {
          throw err;
        }
        return console.log("Written [" + dest + "]");
      });
    });
  });
};

isEmpty = function(dir, cb) {
  return fs.stat(dir, function(err, stat) {
    if (err != null) {
      cb(true);
      return;
    }
    if (stat.isDirectory()) {
      return fs.readdir(dir, function(err, items) {
        if (err != null) {
          return cb(true);
        } else {
          return cb(!items || !items.length);
        }
      });
    } else {
      return cb(false);
    }
  });
};

init = function(dir) {
  return isEmpty(dir, function(empty) {
    if (!empty) {
      return console.log("Cannot init a non-empty directory...");
    } else {
      return gather_input(function(values) {
        console.log("Initialising [" + dir + "]");
        render_template(path.join(__dirname, 'templates', 'nginx.conf.template'), path.join(dir, 'nginx.conf'), values);
        render_template(path.join(__dirname, 'templates', 'bower.json.template'), path.join(dir, 'bower.json'), values);
        render_template(path.join(__dirname, 'templates', 'package.json.template'), path.join(dir, 'package.json'), values);
        render_template(path.join(__dirname, 'templates', 'README.md.template'), path.join(dir, 'README.md'), values);
        render_template(path.join(__dirname, 'templates', 'LICENSE.template'), path.join(dir, 'LICENSE'), values);
        render_template(path.join(__dirname, 'templates', '.gitignore.template'), path.join(dir, '.gitignore'));
        copy_file(path.join(__dirname, 'gruntfile.coffee'), path.join(dir, 'gruntfile.coffee'));
        return ncp(path.join(__dirname, 'src'), path.join(dir, 'src'), function(err) {
          if (err) {
            throw err;
          }
          render_template(path.join(__dirname, 'src', 'site', 'server.coffee'), path.join(dir, 'src', 'site', 'server.coffee'), values);
          return console.log('Done...');
        });
      });
    }
  });
};

cmd = get_command(process.argv);

if ((cmd == null) || ((_ref = cmd.command) !== 'init')) {
  print_help();
  process.exit();
}

if (cmd.command === 'init') {
  dir = process.cwd();
  if (cmd.args.length > 0) {
    dir = cmd.args[0];
  }
  init(dir);
}
