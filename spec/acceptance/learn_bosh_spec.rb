require 'dsl'
require 'helpers'

RSpec.describe Deployment, "#manifest" do

  it "renders the 'learn-bosh' deployment manifest as expected" do

    deployment = Deployment.new.manifest do
      name 'learn-bosh-1'
      director_uuid Helpers::Bosh.director_uuid('bosh-lite')
      releases :array do
        __ do
          release('learn-bosh', 'latest')
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

    expect(deployment.to_yaml).to eq (<<-EOF).gsub(/^\s{6}/, '')
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
    EOF

  end
end