/**
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a
 * copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.jasig.portal.groups.pags.dao.jpa;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Cacheable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.TableGenerator;
import javax.persistence.Version;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.dom4j.DocumentHelper;
import org.dom4j.QName;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;
import org.hibernate.annotations.NaturalIdCache;
import org.jasig.portal.EntityIdentifier;
import org.jasig.portal.groups.pags.dao.IPersonAttributesGroupDefinition;
import org.jasig.portal.groups.pags.dao.IPersonAttributesGroupTestGroupDefinition;

/**
 * @author Shawn Connolly, sconnolly@unicon.net
 */
@Entity
@Table(name = "UP_PAGS_GROUP")
@SequenceGenerator(
        name="UP_PAGS_GROUP_GEN",
        sequenceName="UP_PAGS_GROUP_SEQ",
        allocationSize=5
    )
@TableGenerator(
        name="UP_PAGS_GROUP_GEN",
        pkColumnValue="UP_PAGS_GROUP",
        allocationSize=5
    )
@NaturalIdCache
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class PersonAttributesGroupDefinitionImpl implements IPersonAttributesGroupDefinition {
    public PersonAttributesGroupDefinitionImpl() {
        super();
    }
    public PersonAttributesGroupDefinitionImpl(String name, String description) {
        super();
        this.name = name;
        this.description = description;
    }

    @Id
    @GeneratedValue(generator = "UP_PAGS_GROUP_GEN")
    @Column(name = "PAGS_GROUP_ID")
    private long internalPersonAttributesGroupDefinitionId;

    @Version
    @Column(name = "ENTITY_VERSION")
    private long entityVersion;

    @Column(name = "NAME", length=500, nullable = true)
    private String name;

    @Column(name = "DESCRIPTION", length=500, nullable = true)
    private String description;

    @ManyToMany(cascade=CascadeType.ALL, targetEntity=PersonAttributesGroupDefinitionImpl.class)
    @LazyCollection(LazyCollectionOption.FALSE)
    @JoinTable(name="UP_PAGS_GROUP_MEMBERS", joinColumns = {@JoinColumn(name="PAGS_GROUP_ID")}, inverseJoinColumns={@JoinColumn(name="PAGS_GROUP_MEMBER_ID")})  
    private Set<IPersonAttributesGroupDefinition> members = new HashSet<IPersonAttributesGroupDefinition>(0);

    @ManyToMany(mappedBy = "members", targetEntity=PersonAttributesGroupDefinitionImpl.class)
    private Set<IPersonAttributesGroupDefinition> parents;

    @OneToMany(cascade=CascadeType.ALL, mappedBy="group", targetEntity=PersonAttributesGroupTestGroupDefinitionImpl.class, orphanRemoval=true)
    @LazyCollection(LazyCollectionOption.FALSE)
    private Set<IPersonAttributesGroupTestGroupDefinition> testGroups = new HashSet<IPersonAttributesGroupTestGroupDefinition>(0);

    @Override
    public EntityIdentifier getEntityIdentifier() {
        return new EntityIdentifier(String.valueOf(this.internalPersonAttributesGroupDefinitionId), PersonAttributesGroupDefinitionImpl.class);
    }

    @Override
    public long getId() {
        return internalPersonAttributesGroupDefinitionId;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public Set<IPersonAttributesGroupDefinition> getMembers() {
        // Defensive copy...
        return new HashSet<IPersonAttributesGroupDefinition>(members);
    }

    @Override
    public void setMembers(Set<IPersonAttributesGroupDefinition> members) {
        // We need to replace the contents of the collection, not the reference
        // to the collection itself;  otherwise we mess with Hibernate.
        this.members.clear();
        this.members.addAll(members);
    }

    @Override
    public Set<IPersonAttributesGroupDefinition> getParents() {
        // Defensive copy...
        return new HashSet<IPersonAttributesGroupDefinition>(parents);
    }

    @Override
    public void setParents(Set<IPersonAttributesGroupDefinition> parents) {
        // We need to replace the contents of the collection, not the reference
        // to the collection itself;  otherwise we mess with Hibernate.
        this.parents.clear();
        this.parents.addAll(parents);
    }

    @Override
    public Set<IPersonAttributesGroupTestGroupDefinition> getTestGroups() {
        // Defensive copy...
        return new HashSet<IPersonAttributesGroupTestGroupDefinition>(testGroups);
    }

    @Override
    public void setTestGroups(Set<IPersonAttributesGroupTestGroupDefinition> testGroups) {
        // We need to replace the contents of the collection, not the reference
        // to the collection itself;  otherwise we mess with Hibernate.
        this.testGroups.clear();
        this.testGroups.addAll(testGroups);
    }

    @Override
    public boolean equals(Object that) {
        return EqualsBuilder.reflectionEquals(this, that);
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
    @Override
    public void toElement(org.dom4j.Element parent) {

        if (parent == null) {
            String msg = "Argument 'parent' cannot be null.";
            throw new IllegalArgumentException(msg);
        }

        parent.addElement("name").addText(this.getName());
        parent.addElement("description").addText(this.getDescription());
        if (!members.isEmpty()) {
            org.dom4j.Element elementMembers = DocumentHelper.createElement(new QName("members"));
            for (IPersonAttributesGroupDefinition member : members) {
                elementMembers.addElement("member-name").addText(member.getName());
            }
            parent.add(elementMembers);
        }

        if (!testGroups.isEmpty()) {
            org.dom4j.Element elementSelectionTest = DocumentHelper.createElement(new QName("selection-test"));
            for (IPersonAttributesGroupTestGroupDefinition testGroup : testGroups) {
                testGroup.toElement(elementSelectionTest);
            }
            parent.add(elementSelectionTest);
        }
    }

}
