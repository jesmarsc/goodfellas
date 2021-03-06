package com.kubernetes.konekt.entity;

import java.sql.Blob;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "cluster_info")
@JsonIgnoreProperties({"account", "encryptedUsername", "encryptedPassword"})
public class Cluster {

	//TODO: add to database status
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;

	@Column(name = "cluster_url")
	private String clusterUrl;
	
	@Column(name = "encrypted_username")
	private Blob encryptedUsername;
	
	@Column(name = "encrypted_password")
	private Blob encryptedPassword;
	
	@Column(name = "cluster_status")
	private String status;
	
	@Column(name = "round_robin")
	private Integer roundRobin;

	@ManyToOne(cascade= {CascadeType.DETACH, CascadeType.MERGE,
						 CascadeType.PERSIST, CascadeType.REFRESH})
	@JoinColumn(name="provider_account_id")
	private Account account;
	
	public Cluster() {
	}
	
	public Cluster(String clusterUrl, String clusterUsername, String clusterPassword, 
	        Blob encryptedUsername, Blob encryptedPassword, Integer roundRobin) {
		this.clusterUrl = clusterUrl;
		this.encryptedUsername = encryptedUsername;
		this.encryptedPassword = encryptedPassword;
		this.roundRobin = roundRobin;
		this.status = "Pending";
	}

	public Integer getRoundRobin() {
		return roundRobin;
	}

	public void setRoundRobin(Integer roundRobin) {
		this.roundRobin = roundRobin;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getClusterUrl() {
		return clusterUrl;
	}

	public void setClusterUrl(String clusterUrl) {
		this.clusterUrl = clusterUrl;
	}

	public Blob getEncryptedUsername() {
		return encryptedUsername;
	}

	public void setEncryptedUsername(Blob encryptedUsername) {
		this.encryptedUsername = encryptedUsername;
	}

	public Blob getEncryptedPassword() {
		return encryptedPassword;
	}

	public void setEncryptedPassword(Blob encryptedPassword) {
		this.encryptedPassword = encryptedPassword;
	}


	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	@Override
    public String toString() {
        return "Cluster [id=" + id + ", clusterUrl=" + clusterUrl + ", encryptedUsername=" + encryptedUsername
                + ", encryptedPassword=" + encryptedPassword + ", status=" + status + ", roundRobin=" + roundRobin
                + ", account=" + account + "]";
    }

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	
}
