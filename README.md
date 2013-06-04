#Tasks Project
##Simple tasks application
###Built following tutorial on nettuts
##### [source](http://net.tutsplus.com/tutorials/ruby/the-intro-to-rails-screencast-i-wish-i-had/)

1. rails new tasks -T to build rails project without testing framework (most rail devs prefer Rspec)
2. add gems to Gemfile
group :test, :development do
  gem 'turn' # pretty printing
  gem 'rspec-rails'
  gem 'capybara' # assistant, simulates user
  gem 'guard-rspec' # automatically runs tests
  gem 'ruby_gntp' # notification on mac
end
NOTE: add notification :off to Guardfile to get rid of growl errors
3. run bundle install
4. rails g < what generators available?
5. rails g rspec:install
6. guard init rspec < initialize guard with rspec
7. guard < start guard
8. rails g integration_test tasks
9. go to requests/spec/tasks_spec.rb
10. remove default test inside describe "GET /tasks" do
11. add: 
  it "display some tasks" do
    visit tasks_path
  end
12. add:   config.include Capybara::DSL to line 12 on spec/spec_helper.rb
13. add resource route in config/routes (creates CRUD/REST): resources :tasks
14. on requests/spec/tasks_spec.rb add: page.should have_content 'go to bed'
15. add tasks controller > rails g controller Tasks index 
16. add root :to =>"Tasks#index" to routes.rb to make this default
17. initialize model: rails g model Task task:string [use singular, Active Record can use Task.all for example. task:string is column, no need for primary key, rails does this automatically]
18. rake db:migrate
19. rails console to test db
20. Task.create :task => 'Go to the store'; Task.all, Task.find
21. Add @task =  Task.create :task => 'go to bed' to tasks_spec.rb to test creating new entry
22. Remove turn altogether (uninstall gem + remove from gemfile)
23. Create instance variable in tasks_controller index action
24. In views/tasks/index.html.erb: 
<h1>Tasks</h1>
<ul>
  <% for task in @tasks %>
  <li><%= task.task %></li>
  <% end %>
</ul>
25. rm -rf spec/views (no need for spec/views tests since doing integration tests)
26. Add new test for creating tasks:         
it "creates a new task" do
  visit tasks_path
  fill_in 'Task', :with => 'go to work'
  click_button 'Add Task'

  current_path.should == root_path
  page.should have_content 'go to work'

  save_and_open_page # opens page in browser in this state
27. Add gem 'launchy' # enables save_and_open_page
28. Add form on tasks/index.html.erb
<%= form_for Task.new do |f| %>
  <%= f.label :task %>
  <%= f.text_field :task %>
  <%= f.submit %>
<% end %>
29. Create new action in tasks controller
  def create
    Task.create params[:task]
    redirect_to :back
  end
30. Change tasks_spec to current_path.should == tasks_path
31. Update tasks_spec:

require 'spec_helper'

describe "Tasks" do
  before do
    @task =  Task.create :task => 'go to bed'
  end

  describe "GET /tasks" do
      it "display some tasks" do

        visit tasks_path
        page.should have_content 'go to bed'

      end

      it "creates a new task" do
        visit tasks_path
        fill_in 'Task', :with => 'go to work'
        click_button 'Create Task'

        current_path.should == tasks_path
        page.should have_content 'go to work'

        # save_and_open_page # opens page in browser in this state

      end
  end

  describe "PUT /tasks" do
    it "edits a task" do
      visit tasks_path
      click_link 'Edit'

      current_path.should == edit_task_path(@task)

      # page.should have_content 'go to bed'
      find_field('Task').value.should == 'go to bed'

      fill_in 'Task', :with => 'updated task'
      click_button 'Update Task'

      current_path.should == tasks_path

      page.should have_content 'updated task'

    end
  end
end
32. Add Edit link to index.html:   | <%= link_to 'Edit', edit_task_path(task) %>
33. Move form code from index.html.erb to partial at form.html.erb
34. Put <%= render 'form' %> in both index and edit views
35. Use instance variable @task to replace Task.new in partial, add it to index action (already added to edit)
36. Add update to controller:
  def update
    task = Task.find params[:id]
    if task.update_attributes params[:task]
      redirect_to tasks_path
    else
      redirect_to :back
    end
37. Validation: add validates :task, presence: true to models/task.rb
38. Error handling: in application layout
<% flash.each do |name, message| %>
  <!--<div id="flash_<%= name %>">
  <%= message %>
  </div>-->
  <%= content_tag :div, message, :id => "flash_#{name}" %>
<% end %>
39. In tasks controller:
  def update
    task = Task.find params[:id]
    if task.update_attributes params[:task]
      redirect_to tasks_path, :notice => 'Your task was updated.'
    else
      redirect_to :back, :notice => 'There was an error updating your task.'
    end
40. To delete

  def destroy
    if Task.destroy params[:id]
      redirect_to :back, :notice => 'Task has been deleted'
    else
      redirect_to :back, :notice => 'There has been an error'
    end
  end
