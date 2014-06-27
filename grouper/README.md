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




# Understanding uPortal Permission Model
# Understanding Grouper Permission Model
# Modeling uPortal Permissions in Grouper
Roles, Actions, Hierarchy, Resources, Permission Assignments


### uPortal IPermissionStoreImpl and the GrouperClient
build and pom.xml jar hell
teaching uPortal to use the GrouperClient

