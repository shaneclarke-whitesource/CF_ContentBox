<cfoutput>
<!--- count --->
<input type="hidden" name="authorCount" id="authorCount" value="#prc.authorCount#">
<!--- authors --->
<table name="authors" id="authors" class="table table-striped-removed table-hover " width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
				<input type="checkbox" onClick="checkAll(this.checked,'authorID')"/>
			</th>
			<th>Name</th>
			<th>Role</th>
			<th>Last Login</th>
			<th width="65" class="text-center {sorter: false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.authors#" index="author">
		<tr
			<cfif !author.getIsActive()>
				class="danger"
			</cfif>
			data-authorID="#author.getAuthorID()#" >
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="authorID" id="authorID" value="#author.getAuthorID()#" />
			</td>
			<td>
				<div class="pull-left" style="margin-right: 10px">
					#getInstance( "Avatar@cb" )
						.renderAvatar( email=author.getEmail(), size="40", class="gravatar img-circle" )#
				</div>

				<!--- Display Link if Admin Or yourself --->
				<div>
					<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.oCurrentAuthor.getAuthorID() eq author.getAuthorID()>
						<a href="#event.buildLink(prc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">#author.getName()#</a>
					<cfelse>
						#author.getName()#
					</cfif>

					<cfif prc.oCurrentAuthor.getAuthorID() eq author.getAuthorID()>
						<i class="fa fa-star fa-lg textOrange" title="That's you!"></i>
					</cfif>

					<cfif author.getIs2FactorAuth()>
						<i class="fa fa-mobile fa-lg" title="2 Factor Auth Enabled"></i>
					</cfif>

					<br>
					#author.getEmail()#
				</div>
			</td>

			<td>
				<span class="label label-info">#author.getRole().getRole()#</span>
			</td>

			<td>
				#author.getDisplayLastLogin()#
			</td>

			<td class="text-center">
				<!--- Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-sm btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="User Actions">
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
						<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.oCurrentAuthor.getAuthorID() eq author.getAuthorID()>
							<!--- Delete Command --->
							<cfif prc.oCurrentAuthor.getAuthorID() neq author.getAuthorID()>
								<li>
									<a 	title="Delete Author"
										href="javascript:removeAuthor( '#author.getAuthorID()#' )"
										class="confirmIt"
										data-title="<i class='far fa-trash-alt'></i> Delete Author?"
									>
										<i id="delete_#author.getAuthorID()#" class="far fa-trash-alt fa-lg"></i> Delete
									</a>
								</li>
							<cfelse>
								<li>
									<a 	title="Can't Delete Yourself"
										href="javascript:alert('Can\'t delete yourself buddy!')"
										class="textRed"
									>
										<i id="delete_#author.getAuthorID()#" class="far fa-trash-alt fa-lg"></i> Can't Delete
									</a>
								</li>
							</cfif>

							<!--- Edit Command --->
							<li>
								<a href="#event.buildLink( prc.xehAuthorEditor )#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">
									<i class="fas fa-pen fa-lg"></i> Edit
								</a>
							</li>

							<!--- Export --->
							<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_EXPORT" )>
							<li>
								<a href="#event.buildLink( to=prc.xehExport )#/authorID/#author.getAuthorID()#.json" target="_blank">
									<i class="fas fa-file-export"></i> Export as JSON
								</a>
							</li>
							<li>
								<a href="#event.buildLink( to=prc.xehExport )#/authorID/#author.getAuthorID()#.xml" target="_blank">
									<i class="fas fa-file-export"></i> Export as XML
								</a>
							</li>
							<li>
								<a href="#event.buildLink( to=prc.xehPasswordReset )#/authorID/#author.getAuthorID()#"
									title="Email User a password reset token and link to reset password.">
									<i class="fas fa-key"></i> Reset Password
								</a>
							</li>
							</cfif>
						<cfelse>
							<li><a href="javascript:void(0)"><em>No available actions</em></a></li>
						</cfif>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.showAll>
	#prc.oPaging.renderit(foundRows=prc.authorCount, link=prc.pagingLink, asList=true)#
<cfelse>
	<span class="label label-info">Total Records: #prc.authorCount#</span>
</cfif>

</cfoutput>