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
portal = new AttributeDefNameSave(s, permDef).assignName("apps:portal:roles:portal").assignDisplayExtension("Portal").save();
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

/** Resource Hierachy **/
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
permDef.getAttributeDefActionDelegate().addAction("addTab");
permDef.getAttributeDefActionDelegate().addAction("customize");
permDef.getAttributeDefActionDelegate().addAction("viewUser");
permDef.getAttributeDefActionDelegate().addAction("manage");
permDef.getAttributeDefActionDelegate().addAction("manageApproved");
permDef.getAttributeDefActionDelegate().addAction("manageCreated");
permDef.getAttributeDefActionDelegate().addAction("manageExpired");
permDef.getAttributeDefActionDelegate().addAction("subscribe");
permDef.getAttributeDefActionDelegate().addAction("subscribeApproved");
permDef.getAttributeDefActionDelegate().addAction("subscribeCreated");
permDef.getAttributeDefActionDelegate().addAction("subscribeExpired");

manage = permissionDef.getAttributeDefActionDelegate().findAction("manage", true);
manageApproved = permissionDef.getAttributeDefActionDelegate().findAction("manageApproved", true);
manageCreated = permissionDef.getAttributeDefActionDelegate().findAction("manageCreated", true);
manageExpired = permissionDef.getAttributeDefActionDelegate().findAction("manageExpired", true);

manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manage);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageApproved);
manageExpired.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);

manage.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);
manage.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageApproved);

manageApproved.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(manageCreated);


subscribe = permissionDef.getAttributeDefActionDelegate().findAction("subscribe", true);
subscribeApproved = permissionDef.getAttributeDefActionDelegate().findAction("subscribeApproved", true);
subscribeCreated = permissionDef.getAttributeDefActionDelegate().findAction("subscribeCreated", true);
subscribeExpired = permissionDef.getAttributeDefActionDelegate().findAction("subscribeExpired", true);



read = permissionDef.getAttributeDefActionDelegate().findAction("read", true);
write = permissionDef.getAttributeDefActionDelegate().findAction("write", true);
readWrite = permissionDef.getAttributeDefActionDelegate().findAction("readWrite", true);
admin = permissionDef.getAttributeDefActionDelegate().findAction("admin", true);
 
readWrite.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(read);
readWrite.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(write);
admin.getAttributeAssignActionSetDelegate().addToAttributeAssignActionSet(readWrite);
 
subj0 = addSubject("subj0", "person", "subj0");
subj0 = SubjectFinder.findById("subj0", true);


