class TodosController < ApplicationController

  load_and_authorize_resource

  # GET /todos
  # GET /todos.json
  def index
    if request.referrer.split('/').last == "preview"
      @deleted_from_preview = true
    end

    @todos = Todo.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @todos }
    end
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
    @todo = Todo.find(params[:id])
    @from_preview = false

    @commentable = @todo
    @comments = @commentable.comments
    @comment = Comment.new

    @todo.mark_as_read! :for => current_user
    @todo.comments.each do |comment|
      comment.mark_as_read! :for => current_user
    end

    @active_school_day = most_recent_day_for_material(@todo)
    load_prev_and_next_day

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @todo }
    end
  end

  def preview
    @todo = Todo.find(params[:id])
    @from_preview = true
    render "show_preview", :layout => "preview"
  end

  # GET /todos/new
  # GET /todos/new.json
  def new
    @todo = Todo.new
    @active_school_day = SchoolDay.find(params[:day]) unless params[:day].nil? || params[:day].empty?
    load_prev_and_next_day

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @todo }
    end
  end

  def new_preview
    @todo = Todo.new
    @from_preview = true
    render "form_preview", :layout => "preview"
  end

  # GET /todos/1/edit
  def edit
    @todo = Todo.find(params[:id])

    @todo.mark_as_read! :for => current_user

    @active_school_day = most_recent_day_for_material(@todo)
    load_prev_and_next_day
  end

  def edit_preview
    @todo = Todo.find(params[:id])
    @from_preview = true
    render "form_preview", :layout => "preview"
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(params[:todo])

    respond_to do |format|
      if @todo.save
        if params[:day].nil?
          format.html { redirect_to @todo, notice: 'To-Do was successfully created.' }
          format.json { render json: @todo, status: :created, location: @todo }
        elsif params[:day].empty?
          format.html { redirect_to new_school_day_path + "?todo_added=#{@todo.id}#todos", notice: 'To-Do was successfully created.' }
        else
          format.html { redirect_to edit_school_day_path(SchoolDay.find(params[:day])) + "?todo_added=#{@todo.id}#todos", notice: 'To-Do was successfully created.' }
        end
      else
        if request.referrer.split('/').last == "preview"
          @from_preview = true
          format.html { render "form_preview", :layout => "preview" }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        else
          format.html { render action: "new", :locals => {:day => params[:day]} }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /todos/1
  # PUT /todos/1.json
  def update
    @todo = Todo.find(params[:id])

    respond_to do |format|
      if @todo.update_attributes(params[:todo])
        if request.referrer.split('/').last == "preview"
          format.html { redirect_to todo_preview_path(@todo), notice: 'To-Do was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to @todo, notice: 'To-Do was successfully updated.' }
          format.json { head :no_content }
        end
      else
        if request.referrer.split('/').last == "preview"
          @from_preview = true
          format.html { render "form_preview", :layout => "preview" }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        else
          format.html { render action: "edit" }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_url, notice: "To-Do was successfully deleted." }
      format.json { head :no_content }
    end
  end
end
