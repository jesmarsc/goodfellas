package com.kubernetes.konekt.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kubernetes.konekt.entity.Account;
import com.kubernetes.konekt.entity.Cluster;
import com.kubernetes.konekt.entity.Container;
import com.kubernetes.konekt.form.UploadClusterForm;
import com.kubernetes.konekt.form.UploadContainerToClusterForm;
import com.kubernetes.konekt.service.AccountService;
import com.kubernetes.konekt.service.ClusterService;
import com.kubernetes.konekt.service.ContainerService;

@Controller
public class UploadController {

	@Autowired
	AccountService accountService;
	@Autowired
	ClusterService clusterService;
	
	@Autowired
	ContainerService containerService;
	
	@RequestMapping(value = "/uploadContainerToClusterConfirmation")
	public String uploadContainerToCluster( @ModelAttribute("uploadForm") UploadContainerToClusterForm uploadForm, Model model) {
		String titleMessage;
		String bodyMessage;
		//if cluster ip or container name fields are empty throw error
		if(uploadForm.getClusterIp().isEmpty() || uploadForm.getContainerName().isEmpty()) {
			titleMessage = " Upload Failed";
			bodyMessage = "Cluster or Container was not selected";
			model.addAttribute("bodyMessage", bodyMessage);
			model.addAttribute("titleMessage",titleMessage);
			return "user/container-to-cluster-upload-confirmation";
		}
		titleMessage = "Uploaded Successfully";
		bodyMessage = "You have successfully uploaded " + uploadForm.getContainerName()  + 
				" to cluster with IP address:" +  uploadForm.getClusterIp();
		model.addAttribute("titleMessage", titleMessage);
		model.addAttribute("bodyMessage",bodyMessage);
		return "user/container-to-cluster-upload-confirmation";
	}
	
	
	@RequestMapping(value = "/deleteClusterConfirmation")
	public String deleteCluster( @RequestParam("clusterIp") String clusterIp,Model model) {
		
		Cluster TBDeletedCluster = clusterService.getCluster(clusterIp);
		clusterService.deleteCluster(TBDeletedCluster);
		model.addAttribute("clusterIp", clusterIp);
		return "provider/cluster-deleted-confirmation";
	}
	
	@RequestMapping(value = "/uploadClusterConfirmation")
	public String uploadNewCluster(@Valid @ModelAttribute("newClusterForm") UploadClusterForm uploadClusterForm,BindingResult theBindingResult, Model model) {
		
		if(theBindingResult.hasErrors()) {
			return "provider/provider-dashboard";
		}
		
		// create new cluster from information in form
		Cluster newCluster = new Cluster(uploadClusterForm.getClusterIp());	

		// get current user 
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		Account currentAccount = accountService.findByUserName(username);
		// add new cluster to current user so 
		currentAccount.addCluster(newCluster);
		// push new cluster to cluster table
		if(!clusterService.saveCluster(newCluster)){
			String message = "Invalid IP address. IP address is already in the database";
			model.addAttribute("message",message);
			return "redirect:/provider";
		}
		

		
		model.addAttribute("clusterIp", uploadClusterForm.getClusterIp());
		return "provider/cluster-upload-confirmation";
	}
	
	
	@RequestMapping(value = "/deleteContainerConfirmation")
	public String deleteContainer( @RequestParam("containerName")String containerName, Model model) {
		
		String titleMessage;
		String bodyMessage;
		
		try {
		// get current user 
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		Account currentAccount = accountService.findByUserName(username);
		
		// convert account id to string
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("");
		stringBuilder.append(currentAccount.getId());
		String stringId = stringBuilder.toString();
		
		//Path for container to be deleted
	    String UPLOADED_CONTAINER_PATH = "containers/" + stringId + "/" + containerName;
        Path path = Paths.get(UPLOADED_CONTAINER_PATH);
        
		//delete container from container folder add userid to path
		Files.delete(path);
		
		// delete container information from database
		Container containerTBD = containerService.getContainerByContainerPath(UPLOADED_CONTAINER_PATH);
		containerService.deleteContainer(containerTBD);
		}
		catch(Exception e) {
			e.printStackTrace();
			titleMessage = "Container Delete Failed";
            bodyMessage = "The container: '" + containerName + "' could not be deleted. Container not found in system";
            model.addAttribute("titleMessage", titleMessage);
            model.addAttribute("bodyMessage", bodyMessage);
            return "user/container-delete-confirmation";
		}
		titleMessage = "Container Deleted Successfully";
        bodyMessage = "The container: '" + containerName + "' was successfully deleted from system ";
        model.addAttribute("titleMessage", titleMessage);
        model.addAttribute("bodyMessage", bodyMessage);
		return "user/container-delete-confirmation";
	}
	
	@RequestMapping(value = "/uploadContainerConfirmation")
	public String uploadContainer( @RequestParam("containerFile")MultipartFile file, Model model) {
		

	    String containerName = file.getOriginalFilename();
		String bodyMessage;
		String titleMessage;
		
		// file is empty
		if (file.isEmpty()) {
			titleMessage = "Container Upload Failed";
            bodyMessage = "The container: '" + file.getOriginalFilename() + "' could not be uploaded, chosen file was empty";
            model.addAttribute("titleMessage", titleMessage);
            model.addAttribute("bodyMessage", bodyMessage);
            return "user/container-upload-confirmation";
        }
		// copy information from file and save to new file 
		// where program resides later it will be saved on to 
		// in cloud storage

		try {

            // Get the file and save it somewhere
            byte[] bytes = file.getBytes();
             
			// get current user 
			String username = SecurityContextHolder.getContext().getAuthentication().getName();
			Account currentAccount = accountService.findByUserName(username);
			
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.append("");
			stringBuilder.append(currentAccount.getId());
			String stringId = stringBuilder.toString();
			
			//Directories in path
			String UPLOADED_CONTAINER_DIR = "containers/" + stringId + "/";
			
            // get path object
			Path createDirs = Paths.get(UPLOADED_CONTAINER_DIR);
			
			// create any missing directories
			Files.createDirectories(createDirs);
			
			//Save the uploaded file to this folder
    	    String UPLOADED_CONTAINER_PATH = "containers/" + stringId + "/" + file.getOriginalFilename();

    	    // write container content to user folder
            Path path = Paths.get(UPLOADED_CONTAINER_PATH);
            Files.write(path, bytes);

			// create container object
			Container newContainer = new Container(containerName,UPLOADED_CONTAINER_PATH);

			// add container object to container list of currentAccount
			currentAccount.addContainer(newContainer);
			
			// save container to database call container service
			try {
				containerService.saveContainer(newContainer);
			}
			catch(Exception e) {
				titleMessage = "Container Upload Failed";
				bodyMessage = "The container: '" + file.getOriginalFilename() + "' could not be uploaded because container with that name already exist";
				model.addAttribute("bodyMessage", bodyMessage);
				model.addAttribute("titleMessage", titleMessage);
		        return "user/container-upload-confirmation";
			}


        } catch (IOException e) {
        	
            e.printStackTrace();
            titleMessage = "Container Upload Failed";
            bodyMessage =  "The container: '" + file.getOriginalFilename() + "' could not be uploaded. There was an error uploading the file content";
			model.addAttribute("bodyMessage", bodyMessage);
			model.addAttribute("titleMessage", titleMessage);
            return "uploadStatus";
        }

		titleMessage = "Container Uploaded Succesfully";
		bodyMessage = "You successfully uploaded container: '" + file.getOriginalFilename() + "'";
		model.addAttribute("titleMessage", titleMessage);
		model.addAttribute("bodyMessage", bodyMessage);
		
		return "user/container-upload-confirmation";
	}
	
}
