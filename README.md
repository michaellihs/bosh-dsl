Ruby DSL for BOSH Deployment Manifests
======================================

This project aims to provide a simple Ruby DSL to generate [BOSH](http://bosh.io) [Deployment Manifests](http://bosh.io/docs/deployment-manifest.html).


What does it do?
----------------

Given you want to create the following Deployment Manifest:

    ---
    name: learn-bosh-1
    director_uuid: 1234-1234-1234-1234
    
    releases:
    - name: learn-bosh
      version: latest
    
    jobs:
    - name: app
      templates:
      - name: app
      instances: 1
      resource_pool: default
      networks:
      - name: default
        static_ips:
        - 10.245.0.4

you can use the following Ruby script to do so:

```ruby
Deployment.new.manifest do
  name 'learn-bosh-1'
  director_uuid Helpers::Bosh.director_uuid('bosh-lite')
  releases :array do
    __ do
      name 'learn-bosh'
      version 'latest'
    end
  end
  jobs :array do
    __ do
      name 'app'
      templates :array do
        __ do
          name 'app'
        end
      end
      instances 1
      resource_pool 'default'
      networks :array do
        __ do
          name 'default'
          static_ips ['10.245.0.4']
        end
      end
    end
  end
end
```

Further Resources
=================

* [ENAML - (EN)ough with the y(AML) already](https://github.com/enaml-ops/enaml)
