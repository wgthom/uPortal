s = GrouperSession.startRootSession();

/** Folders **/
a = new StemSave(s).assignName("apps").assignDisplayExtension("Applications").save();
p = new StemSave(s).assignName("apps:portal").assignDisplayExtension("uPortal").save();
r = new StemSave(s).assignName("apps:portal:roles").assignDisplayExtension("uPortal Roles").save();

/** Role Definitions **/
portalSystem = new GroupSave(s).assignName("apps:portal:roles:portalSystem").assignTypeOfGroup(TypeOfGroup.role).save();
portalAdmin = new GroupSave(s).assignName("apps:portal:roles:portalAdministrator").assignTypeOfGroup(TypeOfGroup.role).save();
portalDev = new GroupSave(s).assignName("apps:portal:roles:portalDeveloper").assignTypeOfGroup(TypeOfGroup.role).save();
portalFrag = new GroupSave(s).assignName("apps:portal:roles:portalFragmentOwner").assignTypeOfGroup(TypeOfGroup.role).save();
everyone = new GroupSave(s).assignName("apps:portal:roles:portalEveryone").assignTypeOfGroup(TypeOfGroup.role).save();

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


