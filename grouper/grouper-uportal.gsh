s = GrouperSession.startRootSession();

root = "apps";
portal = root + ":portal";
etc = portal + ":etc";
roles = portal + ":roles";
perms = portal + ":permissions";
portlets = portal + ":portlets";

/** Folders **/
rootStem = new StemSave(s).assignName(apps).assignDisplayExtension("Applications").save();
portalStem = new StemSave(s).assignName(portal).assignDisplayExtension("uPortal").save();
portalEtcStem = new StemSave(s).assignName(etc).assignDisplayExtension("etc").save();
roles = new StemSave(s).assignName(roles).assignDisplayExtension("Roles").save();
perms = new StemSave(s).assignName(perms).assignDisplayExtension("Permissions").save();
portlets = new StemSave(s).assignName(portlets).assignDisplayExtension("Portlets").save();

/** Permission Definitions **/
permErrorChan = perms + ":UP_ERROR_CHAN";
permErrorChanStem = new StemSave(s).assignName(permErrorChan).assignDisplayExtension("Error Channel").save();
errorChanPermDef = new AttributeDefSave(s).assignName(permErrorChan + ":errorChanPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
errorChanPermDef.getAttributeDefActionDelegate().addAction("VIEW");
errorChanDetails = new AttributeDefNameSave(s, errorChanPermDef).assignName(permErrorChan " +:DETAILS").assignDisplayExtension("DETAILS").save();

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

permPortletPublish = perms + ":UP_PORTLET_PUBLISH";
permPortletPublishStem = new StemSave(s).assignName(permPortletPublish).assignDisplayExtension("Portlet Publishing").save();
portletPublishingPermDef = new AttributeDefSave(s).assignName(permPortletPublish + ":portletPublishPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
portletPublishingPermDef.getAttributeDefActionDelegate().addAction("SELECT_PORTLET_TYPE");
portletPublishingPermDef.getAttributeDefActionDelegate().addAction("MANAGE_CREATED");
portletPublishingPermDef.getAttributeDefActionDelegate().addAction("MANAGE_APPROVED");
portletPublishingPermDef.getAttributeDefActionDelegate().addAction("MANAGE");
portletPublishingPermDef.getAttributeDefActionDelegate().addAction("MANAGE_EXPIRED");
portletPublishingPermDef.getAttributeDefActionDelegate().addAction("PORTLET_MODE_CONFIG");

permPortletSubscribe = perms + ":UP_PORTLET_SUBSCRIBE";
permPortletSubscribeStem = new StemSave(s).assignName(permPortletSubscribe).assignDisplayExtension("Portlet Subscribing").save();
portletSubscribePermDef = new AttributeDefSave(s).assignName(permPortletSubscribe + ":portletSubscribePermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("BROWSE");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE_APPROVED");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE_CREATED");
portletSubscribePermDef.getAttributeDefActionDelegate().addAction("SUBSCRIBE_EXPIRED");

/** Permissions controlling the base uPortal system **/
permDef.getAttributeDefActionDelegate().addAction("UP_SYSTEM:ALL_PERMISSIONS");
permDef.getAttributeDefActionDelegate().addAction("UP_SYSTEM:CUSTOMIZE");
permDef.getAttributeDefActionDelegate().addAction("UP_SYSTEM:ADD_TAB");

/** Permissions controlling uPortal user account management **/
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:VIEW_USER_ATTRIBUTE");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:VIEW_USER");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:DELETE_USER");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:EDIT_USER_ATTRIBUTE");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:EDIT_USER");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:IMPERSONATE");

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
subscribeApproved = permDef.getAttributeDefActionDelegate().findAction("UP_PORTLET_SUBSCRIBE:SUBS






/** Role Definitions **/
portalSystem = new GroupSave(s).assignName("apps:portal:roles:system").assignDisplayExtension("System").assignTypeOfGroup(TypeOfGroup.role).save();
portalAdmin = new GroupSave(s).assignName("apps:portal:roles:administrator").assignDisplayExtension("Administrator").assignTypeOfGroup(TypeOfGroup.role).save();
portalDev = new GroupSave(s).assignName("apps:portal:roles:developer").assignDisplayExtension("Developer").assignTypeOfGroup(TypeOfGroup.role).save();
portalFrag = new GroupSave(s).assignName("apps:portal:roles:fragmentOwner").assignDisplayExtension("Fragment Owner").assignTypeOfGroup(TypeOfGroup.role).save();
everyone = new GroupSave(s).assignName("apps:portal:roles:everyone").assignDisplayExtension("Everyone").assignTypeOfGroup(TypeOfGroup.role).save();

/** Role Inheritance **/
portalAdmin.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalSystem);
portalAdmin.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalDev);
portalAdmin.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalFrag);
portalAdmin.getRoleInheritanceDelegate().addRoleToInheritFromThis(everyone);

portalDev.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalSystem);

portalFrag.getRoleInheritanceDelegate().addRoleToInheritFromThis(portalSystem);

/** Permission Definitions **/
permDef = new AttributeDefSave(s).assignName("apps:portal:roles:portalPermDef").assignAttributeDefType(AttributeDefType.perm).assignToEffMembership(true).assignToGroup(true).save();






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


/** Actions **/ 
/** Permissions controlling the rendering of the uPortal error channel **/
permDef.getAttributeDefActionDelegate().addAction("UP_ERROR_CHAN:VIEW");

/** Permissions controlling uPortal DLM fragments **/
permDef.getAttributeDefActionDelegate().addAction("UP_FRAGMENT:FRAGMENT_SUBSCRIBE");

/** Permissions controlling uPortal group and category viewing and management **/
permDef.getAttributeDefActionDelegate().addAction("UP_GROUPS:VIEW_GROUP");
permDef.getAttributeDefActionDelegate().addAction("UP_GROUPS:EDIT_GROUP");
permDef.getAttributeDefActionDelegate().addAction("UP_GROUPS:DELETE_GROUP");
permDef.getAttributeDefActionDelegate().addAction("UP_GROUPS:CREATE_GROUP");

/** Permissions over the viewing and editing of permission owners, activities, and permission assignments **/
permDef.getAttributeDefActionDelegate().addAction("UP_PERMISSIONS:EDIT_PERMISSIONS");
permDef.getAttributeDefActionDelegate().addAction("UP_PERMISSIONS:VIEW_PERMISSIONS");

/** Permissions controlling the publishing and editing of uPortal content **/
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_PUBLISH:SELECT_PORTLET_TYPE");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_PUBLISH:MANAGE_CREATED");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_PUBLISH:MANAGE_APPROVED");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_PUBLISH:MANAGE");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_PUBLISH:MANAGE_EXPIRED");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_PUBLISH:PORTLET_MODE_CONFIG");

/** Permissions controlling the rendering of and subscription to uPortal content **/
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_SUBSCRIBE:BROWSE");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE_APPROVED");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE_CREATED");
permDef.getAttributeDefActionDelegate().addAction("UP_PORTLET_SUBSCRIBE:SUBSCRIBE_EXPIRED");

/** Permissions controlling the base uPortal system **/
permDef.getAttributeDefActionDelegate().addAction("UP_SYSTEM:ALL_PERMISSIONS");
permDef.getAttributeDefActionDelegate().addAction("UP_SYSTEM:CUSTOMIZE");
permDef.getAttributeDefActionDelegate().addAction("UP_SYSTEM:ADD_TAB");

/** Permissions controlling uPortal user account management **/
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:VIEW_USER_ATTRIBUTE");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:VIEW_USER");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:DELETE_USER");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:EDIT_USER_ATTRIBUTE");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:EDIT_USER");
permDef.getAttributeDefActionDelegate().addAction("UP_USERS:IMPERSONATE");

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


