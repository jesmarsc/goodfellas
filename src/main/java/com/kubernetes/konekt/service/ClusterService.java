package com.kubernetes.konekt.service;

import java.util.List;

import com.kubernetes.konekt.entity.Cluster;

public interface ClusterService  {
	
	
	public boolean doesClusterExist(String ClusterIp);

	public List<Cluster> getAllClusters();
	
	public boolean saveCluster(Cluster newCluster);
	
	public Cluster getCluster(String ClusterIp);
	
	public void deleteCluster(Cluster cluster);

	public List<Cluster> getAllAvailableClusters();

	public void updateEntry(Cluster updateCluster);

}
