//
//  SavedPatternsViewController.swift
//  regexy
//
//  Created by Augusto Avelino on 29/03/24.
//

import UIKit

protocol SavedPatternsViewControllerDelegate: AnyObject {
    func didSelectPattern(_ pattern: String, named name: String)
}

class SavedPatternsViewController: DSViewController {
    
    let viewModel: SavedPatternsViewModelProtocol
    weak var delegate: SavedPatternsViewControllerDelegate?
    
    // MARK: UI
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedPatternCell.self, forCellReuseIdentifier: SavedPatternCell.reuseIdentifier)
        return tableView
    }()
    let emptyListView = DSEmptyListView()
    
    // MARK: - Life cycle
    
    init(viewModel: SavedPatternsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func reloadData() {
        do {
            try viewModel.loadData()
            tableView.reloadData()
        } catch RegexDAOError.noContext {
            print("RegexDAOError: Context was not loaded properly")
        } catch {
            debugPrint(error)
        }
        updateEmptyListViewHiddenState()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupEmptyListView()
    }
    
    private func setupNavigationBar() {
        title = "Choose"
        navigationItem.setLeftBarButton(UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { [weak self] action in
            self?.dismiss(animated: true)
        })), animated: false)
        navigationItem.setRightBarButton(UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { [weak self] action in
            guard let self = self,
                    let selectedIndexPath = self.tableView.indexPathForSelectedRow,
                  let selectedItem = self.viewModel.dataForItem(atIndex: selectedIndexPath.row) else { return }
            self.delegate?.didSelectPattern(selectedItem.pattern, named: selectedItem.name)
            self.dismiss(animated: true)
        })), animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.constraintToFill()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupEmptyListView() {
        view.addSubview(emptyListView)
        emptyListView.constraintToFill()
    }
    
    // MARK: - Actions
    
    private func deleteItem(atIndexPath indexPath: IndexPath) -> Bool {
        let removedSuccessfully = viewModel.deleteItem(atIndex: indexPath.row)
        if removedSuccessfully {
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateEmptyListViewHiddenState()
        }
        return removedSuccessfully
    }
    
    private func showDeleteConfirmationAlert(forItemAt indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Delete pattern", message: "Are you sure you wnat to proceed?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let result = self.deleteItem(atIndexPath: indexPath)
            completion(result)
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Display updates
    
    private func updateEmptyListViewHiddenState() {
        emptyListView.isHidden = viewModel.numberOfItems() != 0
    }
}

// MARK: - UITableViewDataSource

extension SavedPatternsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedPatternCell.reuseIdentifier, for: indexPath) as? SavedPatternCell,
              let cellData = viewModel.dataForItem(atIndex: indexPath.row) else { return UITableViewCell() }
        cell.configure(with: cellData)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SavedPatternsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = tableView.indexPathForSelectedRow != nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Remove", handler: { [weak self] _, _, completion in
                guard let self = self else { return }
                self.showDeleteConfirmationAlert(forItemAt: indexPath, completion: completion)
            })
        ])
    }
}
