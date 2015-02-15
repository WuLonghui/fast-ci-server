module Fast
  class JenkinsClient
    
    JOB_CONFIG_TEMPLATE = "job_config.xml.erb"

    def initialize(options)
      @client = JenkinsApi::Client.new(options)
    end
    
    def job_exists?(job_name)
      @client.job.exists?(job_name)
    end
    
    def job_details(job_name)
      @client.job.list_details(job_name)
    end
    
    def create_or_update_job(job_name, job_options={})
      template_file = get_template_file(JOB_CONFIG_TEMPLATE)
      job_config_xml = ERB.new(template_file).result(binding)

      @client.job.create_or_update(job_name, job_config_xml)
    end

    def delete_job!(job_name)
      begin
        delete_job(job_name)
      rescue JenkinsApi::Exceptions::NotFound
      end
    end

    def delete_job(job_name)
      @client.job.wipe_out_workspace(job_name)
      @client.job.delete(job_name) 
    end
    
    def delete_jobs_by_filter
      jobs = @client.job.list_all_with_details
      jobs.each do |job|
        if block_given?
          next unless yield job
        end
        delete_job!(job["name"])
      end
    end
    
    def list_all_jobs
      @client.job.list_all
    end
    
    def list_all_jobs_by_filter(options = {})
      filter_jobs = []
      details = options["details"] || false
      jobs = @client.job.list_all_with_details
      jobs.each do |job|
        if block_given?
          next unless yield job
        end
        
        if details then
          job["current_build_status"] = @client.job.color_to_status(job.delete("color")).upcase
          job["builds"] = get_job_builds(job["name"])
          job_url = job["url"]
          job["build_status_icon"] = {
            "icon" => "#{job_url}/badge/icon",
            "markdown" => "[![Build Status](#{job_url}/badge/icon)](#{job_url})",
            "html" => "<a href='#{job_url}'><img src='#{job_url}/badge/icon'></a>"
          }  
        end
        filter_jobs << job
      end 
      filter_jobs
    end
    
    def get_job_builds(job_name)
      builds = @client.job.get_builds(job_name)
      builds.each do |build|
        build_details = @client.job.get_build_details(job_name, build["number"])
        build["result"] = build_details["result"]
        build["time"] = build_details["id"] 
      end
      builds
    end
    
    def add_user(username, password)
      @client.exec_script("jenkins.model.Jenkins.instance.securityRealm.createAccount(\"#{username}\", \"#{password}\")")
    end

    def delete_user(username)
      @client.exec_script("hudson.model.User.get(\"#{username}\").delete()")
    end

    def get_template_file(template_file_name)
      File.read( File.expand_path("../../assets/jenkins/#{template_file_name}", __FILE__) )
    end
  end
end
