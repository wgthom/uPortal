s = GrouperSession.startRootSession();

root = "apps";
portal = root + ":portal";
etc = portal + ":etc";
roles = portal + ":roles";
perms = portal + ":permissions";
portlets = portal + ":portlets";

/** Folders **/
rootStem = new StemSave(s).assignName(root).assignDisplayExtension("Applications").save();
portalStem = new StemSave(s).assignName(portal).assignDisplayExtension("uPortal").save();
portalEtcStem = new StemSave(s).assignName(etc).assignDisplayExtension("etc").save();
rolesStem = new StemSave(s).assignName(roles).assignDisplayExtension("Roles").save();
permsStem = new StemSave(s).assignName(perms).assignDisplayExtension("Permissions").save();
portletsStem = new StemSave(s).assignName(portlets).assignDisplayExtension("Portlets").save();

/** Role Definitions **/
portalSystem = new GroupSave(s).assignName(roles + ":system").assignDisplayExtension("Portal System").assignTypeOfGroup(TypeOfGroup.role).save();
portalAdmin = new GroupSave(s).assignName(roles + ":administrator").assignDisplayExtension("Portal Administrators").assignTypeOfGroup(TypeOfGroup.role).save();
portalDev = new GroupSave(s).assignName(roles + ":developer").assignDisplayExtension("Portal Developers").assignTypeOfGroup(TypeOfGroup.role).save();
portalFrag = new GroupSave(s).assignName(roles + ":fragmentOwner").assignDisplayExtension("Fragment Owners").assignTypeOfGroup(TypeOfGroup.role).save();
everyone = new GroupSave(s).assignName(roles + ":everyone").assignDisplayExtension("Everyone").assignTypeOfGroup(TypeOfGroup.role).save();

/** Role Inheritance **/
portalAdmin.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalSystem);
portalDev.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalSystem);
portalFrag.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalSystem);
portalSystem.getRoleInheritanceDelegate().addRoleToInheritFromThis(everyone);


/** Permission Definitions **/
permErrorChan = perms + ":UP_ERROR_CHAN";
permErrorChanStem = new StemSave(s).assignName(permErrorChan).assignDisplayExtension("Error Channel").save();
errorChanPermDef = new AttributeDefSave(s).assignName(permErrorChan + ":errorChanPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
errorChanPermDef.getAttributeDefActionDelegate().addAction("VIEW");
errorChanDetails = new AttributeDefNameSave(s, errorChanPermDef).assignName(permErrorChan + ":DETAILS").assignDisplayExtension("DETAILS").assignDescription("Stack Trace").save();



permFragment = perms + ":UP_FRAGMENT";
permFragmentStem = new StemSave(s).assignName(permFragment).assignDisplayExtension("Fragments").save();
fragmentPermDef = new AttributeDefSave(s).assignName(permFragment + ":fragmentPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
fragmentPermDef.getAttributeDefActionDelegate().addAction("FRAGMENT_SUBSCRIBE");
// todo where are fragment resources defined?  <group>Subscribable Fragments</group>

permGroups = perms + ":UP_GROUPS";
permGroupsStem = new StemSave(s).assignName(permGroups).assignDisplayExtension("Groups").save();
groupsPermDef = new AttributeDefSave(s).assignName(permGroups + ":groupsPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
groupsPermDef.getAttributeDefActionDelegate().addAction("VIEW_GROUP");
groupsPermDef.getAttributeDefActionDelegate().addAction("EDIT_GROUP");
groupsPermDef.getAttributeDefActionDelegate().addAction("DELETE_GROUP");
groupsPermDef.getAttributeDefActionDelegate().addAction("CREATE_GROUP");

permPermissions = perms + ":UP_PERMISSIONS";
permPermissionsStem = new StemSave(s).assignName(permPermissions).assignDisplayExtension("uPortal Permissions").save();
permissionsPermDef = new AttributeDefSave(s).assignName(permGroups + ":permissionsPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
permissionsPermDef.getAttributeDefActionDelegate().addAction("EDIT_PERMISSIONS");
permissionsPermDef.getAttributeDefActionDelegate().addAction("VIEW_PERMISSIONS");

/** Permissions controlling the publishing and editing of uPortal content **/
permPortletPublish = perms + ":UP_PORTLET_PUBLISH";
permPortletPublishStem = new StemSave(s).assignName(permPortletPublish).assignDisplayExtension("Portlet Publishing").save();
portletPublishPermDef = new AttributeDefSave(s).assignName(permPortletPublish + ":portletPublishPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
portletPublishPermDef.getAttributeDefActionDelegate().addAction("SELECT_PORTLET_TYPE");
portletPublishPermDef.getAttributeDefActionDelegate().addAction("MANAGE_CREATED");
portletPublishPermDef.getAttributeDefActionDelegate().addAction("MANAGE_APPROVED");
portletPublishPermDef.getAttributeDefActionDelegate().addAction("MANAGE");
portletPublishPermDef.getAttributeDefActionDelegate().addAction("MANAGE_EXPIRED");
portletPublishPermDef.getAttributeDefActionDelegate().addAction("PORTLET_MODE_CONFIG");





/** UP_PORTLET_PUBLISH Action Hierarchy ** /
manage = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE", true);
manageApproved = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE_APPROVED", true);
manageCreated = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE_CREATED", true);
manageExpired = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE_EXPIRED", true);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manage);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageApproved);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);
manage.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);
manage.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageApproved);
manageApproved.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);

permPortletSubscribe = perms + ":UP_PORTLET_SUBSCRIBE";
permPortletSubscribeStem = new StemSave(s).assignName(permPortletSubscribe).assignDisplayExtension("Portlet Subscribing").save();
portletSubscribePermDef = new AttributeDefSave(s).assignName(permPortletSubscribe + ":portletSubscribePermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("BROWSE");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE_APPROVED");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE_CREATED");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE_EXPIRED");

permPortalSystem = perms + ":UP_SYSTEM";
permPortalSystemStem = new StemSave(s).assignName(permPortalSystem).assignDisplayExtension("uPortal System").save();
portalSystemPermDef = new AttributeDefSave(s).assignName(permPortalSystem + ":portalSystemPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
portalSystemPermDef.getAttributeDefActionDelegate().addAction("ALL_PERMISSIONS");
portalSystemPermDef.getAttributeDefActionDelegate().addAction("CUSTOMIZE");
portalSystemPermDef.getAttributeDefActionDelegate().addAction("ADD_TAB");

/** Permissions controlling uPortal user account management **/
permUsers = perms + ":UP_USERS";
permUsersStem = new StemSave(s).assignName(permUsers).assignDisplayExtension("Users").save();
usersPermDef = new AttributeDefSave(s).assignName(permUsers + ":usersPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
usersPermDef.getAttributeDefActionDelegate().addAction("VIEW_USER_ATTRIBUTE");
usersPermDef.getAttributeDefActionDelegate().addAction("VIEW_USER");
usersPermDef.getAttributeDefActionDelegate().addAction("DELETE_USER");
usersPermDef.getAttributeDefActionDelegate().addAction("EDIT_USER_ATTRIBUTE");
usersPermDef.getAttributeDefActionDelegate().addAction("EDIT_USER");
usersPermDef.getAttributeDefActionDelegate().addAction("IMPERSONATE");



subscribe = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE", true);
subscribeApproved = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBS




/** Resources **/
/** The portal **/
portal = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:portal").assignDisplayExtension("Portal").save();

/** Portlets **/
// TODO add portlets
pAttachments = new AttributeDefNameSave(s, permDef).assignName("apps:portal:attachmentsPortlet").assignDisplayExtension("Attachments Portlet").save();



/** Portlet Categories **/
allPortlets = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:allPortlets").assignDisplayExtension("All Portlets").save();
academics = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:academics").assignDisplayExtension("Academics").save();
advisors = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:advisors").assignDisplayExtension("Advisors").save();
demonstration = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:demonstration").assignDisplayExtension("Demonstration").save();
development = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:development").assignDisplayExtension("Development").save();
entertainment = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:entertainment").assignDisplayExtension("Entertainment").save();
finances = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:finances").assignDisplayExtension("Finances").save();
information = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:information").assignDisplayExtension("Information").save();
instructors = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:instructors").assignDisplayExtension("Instructors").save();
libraries = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:libraries").assignDisplayExtension("Libraries").save();
news = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:news").assignDisplayExtension("News").save();
research = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:research").assignDisplayExtension("Research").save();
services = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:services").assignDisplayExtension("Services").save();
testing = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:testing").assignDisplayExtension("Testing").save();
work = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:work").assignDisplayExtension("Work").save();
uPortal = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:uPortal").assignDisplayExtension("uPortal").save();

/** Portlet Category Hierarchy **/
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(academics);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(advisors);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(demonstration);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(development);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(entertainment);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(finances);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(information);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(instructors);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(libraries);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(news);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(research);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(services);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(testing);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(work);
allPortlets.getAttributeDefNameSetDelegate().addToAttributeDefNameSet(uPortal);



/** Action Hierarchy ** /
manage = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE", true);
manageApproved = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE_APPROVED", true);
manageCreated = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE_CREATED", true);
manageExpired = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_PUBLISH:MANAGE_EXPIRED", true);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manage);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageApproved);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);
manage.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);
manage.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageApproved);
manageApproved.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);

subscribe = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE", true);
subscribeApproved = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE_APPROVED", true);
subscribeCreated = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE_CREATED", true);
subscribeExpired = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE_EXPIRED", true);




read = permissionDef.getAttributeDefActionDelegate().findAction("read", true);
write = permissionDef.getAttributeDefActionDelegate().findAction("write", true);
readWrite = permissionDef.getAttributeDefActionDelegate().findAction("readWrite", true);
admin = permissionDef.getAttributeDefActionDelegate().findAction("admin", true);
 
readWrite.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(read);
readWrite.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(write);
admin.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(readWrite);
 
subj0 = addSubject("subj0", "person", "subj0");
subj0 = SubjectFinder.findById("subj0", true);


