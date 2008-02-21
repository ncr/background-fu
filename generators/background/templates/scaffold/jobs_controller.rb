class JobsController < ApplicationController

  def index
    @jobs = Job.find(:all)
  end

  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page[@job].replace :partial => "job"
        end
      end
    end
  end
  
  def create
    params[:job][:args] = params[:job][:args].split("\n").map(&:strip)
    @job = Job.new(params[:job])
    
    if @job.save
      redirect_to jobs_path
    else
      render :action => "new"
    end
  end

  def update
    @job = Job.find(params[:id])
    
    if params[:command] == "stop"
      @job.stop!
    elsif params[:command] == "restart" 
      @job.restart!
    end

    render :update do |page|
      page[@job].replace :partial => "job"
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    render :update do |page|
      page[@job].replace :partial => "job_deleted", :object => @job
    end
  end

end
