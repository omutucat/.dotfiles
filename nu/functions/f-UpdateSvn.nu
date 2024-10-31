export def --env UpdateSvn [] {
  let svnRepos = ls | where {|x| ls -a $x.name | any {|y| $y.name | str ends-with ".svn"}}

  $svnRepos | each {|repo| echo "Updating ($repo.name)"; svn update $repo.name}
}
