require 'test/helper'

class Admin::TableHelperTest < ActiveSupport::TestCase

  include Admin::TableHelper

  include ActionView::Helpers::UrlHelper
  include ActionController::UrlWriter

  def test_build_typus_table
    assert true
  end

  def test_typus_table_header

    @current_user = mock()
    @current_user.expects(:can_perform?).with(TypusUser, 'delete').returns(true)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => 'admin/typus_users', :action => 'index' }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)
    expected = <<-HTML
<tr>
<th><a href="http://test.host/admin/typus_users?order_by=email"><div class="">Email</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=role"><div class="">Role</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=status"><div class="">Status</div></a></th>
<th>&nbsp;</th>
</tr>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_header_with_params

    @current_user = mock()
    @current_user.expects(:can_perform?).with(TypusUser, 'delete').returns(true)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => 'admin/typus_users', :action => 'index', :search => 'admin' }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)
    expected = <<-HTML
<tr>
<th><a href="http://test.host/admin/typus_users?order_by=email&search=admin"><div class="">Email</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=role&search=admin"><div class="">Role</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=status&search=admin"><div class="">Status</div></a></th>
<th>&nbsp;</th>
</tr>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_header_when_user_cannot_delete_items

    @current_user = mock()
    @current_user.expects(:can_perform?).with(TypusUser, 'delete').returns(false)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => 'admin/typus_users', :action => 'index' }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)
    expected = <<-HTML
<tr>
<th><a href="http://test.host/admin/typus_users?order_by=email"><div class="">Email</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=role"><div class="">Role</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=status"><div class="">Status</div></a></th>
</tr>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_header_when_user_cannot_delete_items_with_params

    @current_user = mock()
    @current_user.expects(:can_perform?).with(TypusUser, 'delete').returns(false)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => 'admin/typus_users', :action => 'index', :search => 'admin' }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)
    expected = <<-HTML
<tr>
<th><a href="http://test.host/admin/typus_users?order_by=email&search=admin"><div class="">Email</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=role&search=admin"><div class="">Role</div></a></th>
<th><a href="http://test.host/admin/typus_users?order_by=status&search=admin"><div class="">Status</div></a></th>
</tr>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_belongs_to_field

    comment = comments(:without_post_id)
    output = typus_table_belongs_to_field('post', comment)
    expected = <<-HTML
<td></td>
    HTML

    assert_equal expected, output
    default_url_options[:host] = 'test.host'

    comment = comments(:with_post_id)
    output = typus_table_belongs_to_field('post', comment)
    expected = <<-HTML
<td><a href="http://test.host/admin/posts/edit/1">Post#1</a></td>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_has_and_belongs_to_many_field

    post = Post.find(1)

    output = typus_table_has_and_belongs_to_many_field('comments', post)
    expected = <<-HTML
<td>John<br />Me<br />Me</td>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_string_field

    post = posts(:published)
    output = typus_table_string_field(:title, post, :created_at)
    expected = <<-HTML
<td>#{post.title}</td>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_string_field_with_link

    post = posts(:published)
    output = typus_table_string_field(:title, post, :title)
    expected = <<-HTML
<td><a href="http://test.host/admin/posts/edit/#{post.id}">#{post.title}</a></td>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_tree_field

    return if !defined?(ActiveRecord::Acts::Tree)

    page = pages(:published)
    output = typus_table_tree_field('test', page)
    expected = <<-HTML
<td></td>
    HTML

    assert_equal expected, output

    page = pages(:unpublished)
    output = typus_table_tree_field('test', page)
    expected = <<-HTML
<td>Page#1</td>
    HTML

    assert_equal expected, output

  end

=begin

  # FIXME

  def test_typus_table_position_field

    category = categories(:first)
    output = typus_table_position_field('position', category)
    expected = ""

    assert_equal expected, output

  end

=end

  def test_typus_table_datetime_field

    post = posts(:published)
    Time::DATE_FORMATS[:post_short] = '%m/%y'

    output = typus_table_datetime_field(:created_at, post)
    expected = <<-HTML
<td>#{post.created_at.strftime('%m/%y')}</td>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_datetime_field_with_link

    post = posts(:published)
    Time::DATE_FORMATS[:post_short] = '%m/%y'

    output = typus_table_datetime_field(:created_at, post, :created_at)
    expected = <<-HTML
<td><a href="http://test.host/admin/posts/edit/#{post.id}">#{post.created_at.strftime('%m/%y')}</a></td>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_boolean_field

    options = { :icon_on_boolean => false, :toggle => false }
    Typus::Configuration.stubs(:options).returns(options)

    post = posts(:published)
    output = typus_table_boolean_field('status', post)
    expected = <<-HTML
<td align="center">True</td>
    HTML

    assert_equal expected, output

    post = posts(:unpublished)
    output = typus_table_boolean_field('status', post)
    expected = <<-HTML
<td align="center">False</td>
    HTML

    assert_equal expected, output

  end

end