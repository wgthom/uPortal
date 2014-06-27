# Exploring Grouper for Groups and Permissions in uPortal

The Groups and Permissions (GAPS) subsystem of uPortal is a local to uPortal system for dealing with groups and permissions.  Groups are used to drive a variety of portal behavior and as targets (aka resources) for permission assignments.  While GAPS has served uPortal well over the years it is specific to uPortal and comes with a maintenance burden requiring resources that may be better allocated elsewhere.

Grouper is a groups and permission management system that is designed specifically for that task, but alas was not yet available when GAPS was created.

At the 2014 Apereo Unconference and again at the 2014 Apereo conference the topic of migrated uPortal's group and permissions needs to Grouper and retiring GAPS was discussed. Some of the benefits that may result by adopting Grouper in uPortal are:
* Reduce uPortal code maintenance burden by adopting Grouper and Spring Security or Apache Shiro and removing GAPSs
* Grouper is a more full featured grouper and permission management system
* Schools with Grouper deployed could leverage institution data driven groups and permissions within uPortal.
* uPortal database schema is reduced and simplified

In order to more fully understand the possibilities, difficulties, and potential work involved in adopting Grouper for uPortal this exploration and technical spike solution was developed.  Work to incorporate Grouper Groups via GAP plugin has be previously completed.  This current exploration is about leveraging Groupers permission system.

## Previous Work

Assessment of Grouper and uPortal  (2005)
https://wiki.jasig.org/display/GAP/Grouper

Comparing the uPortal Groups Service and Grouper (2005)
http://lutung.lib.ums.ac.id/arsip/software/sso/CAS/docs/GAP/Comparing+the+uPortal+Groups+Service+and+Grouper.html

Using Grouper for group management in uPortal (2012)
https://spaces.internet2.edu/display/Grouper/Grouper-uPortal

## uPortal Permissions
uPortal permssions model is descriped in the uPortal 4.0 Manual under About Permissions.  https://wiki.jasig.org/display/UPM40/About+uPortal+Permissions

One can map uPortal Permission concepts to Grouper as follows:

| uPortal | Grouper |
| ------- | ------- |
| Principal | Subject |
| Activity | Action |
| Target | Resource |
| Owner | Permission Definition |

A key part of this work is understanding how uPortal defines it's base permission model and translating that to Grouper.

## uPortal Permission Definitions
uPortal defines a number of "default entities" in various sets of XML files in uportal-war/src/main/data/default_entities

For the purposes of this exploration we are mostly concerned with:
* Permission Definitions
** uportal-war/src/main/data/default\_entities/permission\_owner
* Permission Assignments
** uportal-war/src/main/data/default\_entities/permission\_set

## uPortal to Grouper Translation

### Owner to Permission Definition
uPortal Permission System Terminology defines an Owner as a "Permissions category used to organize activities."  Activities are called Actions in Grouper and are organized in Permission Definitions.

uportal-war/src/main/data/default\_entities/permission\_owner\UP\_ERROR\_CHAN.permission-owner.xml provides this permission definition:

```xml
<permission-owner>
    <name>Error Channel</name>
    <fname>UP_ERROR_CHAN</fname>
    <desc>Permissions controlling the rendering of the uPortal error channel</desc>
    <activity>
        <name>View</name>
        <fname>VIEW</fname>
        <desc></desc>
        <targetProvider>errorChannelTargetProvider</targetProvider>
    </activity>
</permission-owner>
```

which we can translation into a Grouper Permission Definition:
![Grouper Error Channel Permission Definition](https://raw.githubusercontent.com/wgthom/uPortal/uportal-grouper/grouper/up_error_chan_permDef.png)











# Understanding uPortal Permission Model
# Understanding Grouper Permission Model
# Modeling uPortal Permissions in Grouper
Roles, Actions, Hierarchy, Resources, Permission Assignments


### uPortal IPermissionStoreImpl and the GrouperClient
build and pom.xml jar hell
teaching uPortal to use the GrouperClient

