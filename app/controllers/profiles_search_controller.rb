class ProfilesSearchController < ApplicationController
  def show
    @profiles = ProfilesSearch.new(params[:search]).results.page(params[:page]).per(16)

# todo: add params search languages
    if params[:search].include? :quick
      search_params = params[:search][:quick]
    else
      search_params = params[:search][:name] + " " + params[:search][:city] + " " + params[:search][:twitter] + " " + params[:search][:topics]
    end

    if @profiles.any?
      flash[:notice] = (I18n.t(:success, scope: 'search', searchparams: search_params).html_safe) + (I18n.t(:result, scope: 'search', count: @profiles.size).html_safe)
    else
      flash[:notice] = (I18n.t(:empty, scope: 'search', searchparams: search_params).html_safe)
    end
  end
end
